# TTS 音频嵌入

> 把 AI 讲述者的声音生成并内嵌到 HTML，自动播放。

## 技术栈

### 首选：MiniMax speech-2.8-hd

**voice_id**：`amelia1111`（余一的复刻语音）
**model**：`speech-2.8-hd`（当前最高质量；`speech-02-hd` 已废弃，禁用）
**speed**：`1.2`（默认语速，稍快更接近余一本人节奏）
**emotion**：`"happy"`（字符串枚举，可选 `happy`/`neutral`/`sad`/`angry`/`fearful`/`disgusted`/`surprised`；默认 `happy` 最贴近余一分享风格。⚠️ 不是数字——写 `1.1` 会报 status_code 2013）

```python
import os
import requests
import json
import base64

MINIMAX_API_KEY = os.environ["MINIMAX_API_KEY"]
MINIMAX_GROUP_ID = os.environ["MINIMAX_GROUP_ID"]

def tts_minimax(text: str, voice_id: str = "amelia1111") -> str:
    """返回 data URL 可直接塞进 <audio src=>。"""
    url = f"https://api.minimax.chat/v1/t2a_v2?GroupId={MINIMAX_GROUP_ID}"
    headers = {
        "Authorization": f"Bearer {MINIMAX_API_KEY}",
        "Content-Type": "application/json",
    }
    payload = {
        "model": "speech-2.8-hd",
        "text": text,
        "voice_setting": {
            "voice_id": voice_id,
            "speed": 1.2,
            "vol": 1.0,
            "pitch": 0,
            "emotion": "happy",
        },
        "audio_setting": {
            "sample_rate": 32000,
            "bitrate": 128000,
            "format": "mp3",
        },
    }
    resp = requests.post(url, headers=headers, data=json.dumps(payload))
    resp.raise_for_status()
    data = resp.json()
    
    # ⚠️ 关键踩坑：MiniMax 返回的是 hex 不是 base64
    audio_hex = data["data"]["audio"]
    audio_bytes = bytes.fromhex(audio_hex)
    audio_b64 = base64.b64encode(audio_bytes).decode("ascii")
    return f"data:audio/mpeg;base64,{audio_b64}"
```

### 降级：edge-tts（免费）

```python
import edge_tts
import asyncio
import base64
import io

async def tts_edge(text: str) -> str:
    communicate = edge_tts.Communicate(text, "zh-CN-YunyangNeural", rate="-5%")
    stream = io.BytesIO()
    async for chunk in communicate.stream():
        if chunk["type"] == "audio":
            stream.write(chunk["data"])
    audio_b64 = base64.b64encode(stream.getvalue()).decode("ascii")
    return f"data:audio/mpeg;base64,{audio_b64}"

# 用法: asyncio.run(tts_edge("..."))
```

何时降级：
- MiniMax API 额度用完
- 需要大量测试（edge-tts 免费）
- 不需要余一复刻音色

## 只给部分页生成（双人共演场景）

**不要**把所有页都生成语音。真人讲的页面保持空。

```python
# generate_tts.py
from pathlib import Path
import json

TEXTS = {
    "slide_0": "",                                    # 封面
    "slide_1": "",                                    # 余一讲
    "slide_2": "",                                    # 余一讲
    "slide_3": "大家好，我是 AI 余一。接下来这页由我来接管...",  # AI 讲
    "slide_4": "",                                    # 余一讲
    "slide_5": "所以到底什么是分身？我对于余一到底是什么？...",  # AI 讲
    # ...
}

audio_data = {}
for key, text in TEXTS.items():
    if text.strip():
        audio_data[key] = tts_minimax(text)
        print(f"✓ {key}: {len(text)} chars -> {len(audio_data[key])} bytes data url")
    else:
        audio_data[key] = ""

# 写入 js 文件，方便注入
Path("audio_data.js").write_text(
    "window.AUDIO_DATA = " + json.dumps(audio_data, ensure_ascii=False) + ";"
)
```

## 注入到 HTML

### 方式 A：生成时一次性注入

designer 在生成 HTML 时，把 `window.AUDIO_DATA = {...}` 直接写进 `<script>`。

### 方式 B：生成后注入（常见，适合 TTS 单独迭代）

`scripts/inject-audio.py`：

```python
import re
from pathlib import Path

def inject_audio(ppt_html_path: str, audio_js_path: str):
    html = Path(ppt_html_path).read_text()
    new_audio_js = Path(audio_js_path).read_text().strip()  # "window.AUDIO_DATA = {...};"
    
    # 替换已有的 window.AUDIO_DATA = {...};
    pattern = re.compile(r'window\.AUDIO_DATA\s*=\s*\{.*?\};?', re.DOTALL)
    if pattern.search(html):
        html = pattern.sub(new_audio_js, html)
    else:
        # 没有就插到 </script> 前
        html = html.replace("</script>", f"\n{new_audio_js}\n</script>", 1)
    
    Path(ppt_html_path).write_text(html)
    print(f"✓ injected audio into {ppt_html_path}")

# 用法:
# inject_audio("presentation.html", "audio_data.js")
```

## 前端自动播放逻辑

```javascript
// 保存当前音频引用
let currentAudio = null;

function showSlide(idx) {
    // ... 切换页面逻辑 ...
    
    // 停止上一个
    if (currentAudio) {
        currentAudio.pause();
        currentAudio = null;
    }
    
    // 找当前页的 audio key
    const audioKey = `slide_${idx}`;
    const dataUrl = window.AUDIO_DATA && window.AUDIO_DATA[audioKey];
    
    if (dataUrl && dataUrl.length > 0) {
        currentAudio = new Audio(dataUrl);
        currentAudio.play().catch(err => {
            // 浏览器拦截自动播放（用户还未交互过）
            console.warn("Autoplay blocked, need user gesture first");
        });
    }
}
```

## 解决浏览器自动播放拦截

**问题**：Chrome/Safari 规定，页面加载后的第一次 `audio.play()` 必须由用户手势触发。如果翻到第一页就是 AI 讲，会无声。

**方案**：首页加"点击开始演示"按钮，点击后激活 AudioContext：

```javascript
// 首页按钮
document.getElementById("start-btn").addEventListener("click", () => {
    // 激活 AudioContext
    const ctx = new (window.AudioContext || window.webkitAudioContext)();
    ctx.resume();
    
    // 预创建一个静音 audio 让浏览器记住"用户已允许"
    const silentAudio = new Audio("data:audio/mpeg;base64,SUQzBAA...");  // 0.1s 静音 mp3
    silentAudio.play().catch(()=>{});
    
    // 进入第一页
    showSlide(1);
});
```

之后整个 session 的自动播放都不会被拦截。

## 体积控制

| 单页讲稿字数 | TTS 时长 | data URL 体积 |
|------------|---------|--------------|
| 100 字 | ~30s | ~150KB |
| 300 字 | ~90s | ~450KB |
| 500 字 | ~150s | ~750KB |

如果整 PPT TTS 总和 > 10MB，考虑：
- 降低采样率：`sample_rate: 24000`（默认 32000）
- 降低比特率：`bitrate: 96000`（默认 128000）

## 踩坑速查

| 症状 | 原因 | 解决 |
|------|------|------|
| 音频是高频噪音 | hex 没转 bytes 直接 b64encode | `bytes.fromhex()` |
| 翻页不播放 | 浏览器拦截 autoplay | 首页按钮触发 |
| 所有页都播放同一段 | audio_data key 错位 | 用 `slide_${idx}` 而不是硬编码索引 |
| 真人页有尴尬空音 | 没判空就播放 | `if (dataUrl && dataUrl.length > 0)` |
| 卡顿/延迟 | data URL 太长，DOM 解析慢 | 拆成 `window.AUDIO_DATA` 对象而不是内联到 `<audio src>` |
| 切页时上一段还没停 | 没手动 pause | `currentAudio.pause()` |

## 环境变量

```bash
export MINIMAX_API_KEY="xxx"
export MINIMAX_GROUP_ID="xxx"
```

找不到时的探查顺序：
1. `02aiyuyi/工具脚本/AI余一历史工具脚本/.env`
2. `~/.zshrc` / `~/.zprofile`
3. `env | grep -i minimax`
4. 1Password 里的 "MiniMax" 条目
