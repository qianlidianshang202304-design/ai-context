# 全资源 base64 内嵌到单 HTML

> 核心目标：一个 `.html` 文件，断网打开，所有图片/音频/视频/字体都在。

## 为什么必须内嵌

- **演讲现场没 WiFi**：远程服务器/CDN 在内网被墙。
- **发给别人**：微信/邮件发一个 html，对方直接能看。
- **版本稳定**：外部资源可能随时被删，PPT 跟着烂。
- **隐私安全**：不想让第三方知道你打开了什么。

## 内嵌清单（按资源类型）

### 1. 图片

```python
import base64
from pathlib import Path

def img_to_base64(path: str) -> str:
    ext = Path(path).suffix.lstrip('.').lower()
    mime = {'jpg': 'jpeg', 'jpeg': 'jpeg', 'png': 'png', 'webp': 'webp', 'gif': 'gif', 'svg': 'svg+xml'}[ext]
    with open(path, 'rb') as f:
        b64 = base64.b64encode(f.read()).decode('ascii')
    return f"data:image/{mime};base64,{b64}"

# 用法
html = html.replace('{{AVATAR}}', img_to_base64('assets/avatar.webp'))
```

**压缩优先**（图片体积 > 200KB 就要压缩）：
- PNG → WebP：`cwebp -q 80 input.png -o output.webp`（体积一般减 60-80%）
- 大照片 → JPEG `-q 75`
- 图示/Logo → SVG（原生文本，体积最小）
- Emoji 图标 → Unicode 字符直接写在 HTML，不用图片

### 2. 音频（TTS）

MiniMax 返回的是 **hex**，不是 base64，必须转换：

```python
audio_hex = response['data']['audio']
audio_bytes = bytes.fromhex(audio_hex)  # ← 关键
audio_b64 = base64.b64encode(audio_bytes).decode('ascii')
data_url = f"data:audio/mpeg;base64,{audio_b64}"
```

**单页音频典型大小**：1 分钟 mp3 ≈ 300-500KB。10 页语音 ≈ 3-5MB，可接受。

### 3. 视频

**能不嵌就不嵌**。视频体积大（1 分钟 720p ≈ 10-30MB），会让 HTML 卡。
替代方案：
- 截图 + 说明文字
- GIF（≤ 3 秒循环片段）
- 要真视频 → 单独放 `assets/demo.mp4`，html 里引用相对路径（放弃绝对自包含，换体积）
- 必须嵌 → 压到 480p、h265、< 5MB，再 base64

```python
video_b64 = base64.b64encode(open('demo.mp4', 'rb').read()).decode('ascii')
# <video src="data:video/mp4;base64,{{VIDEO}}" autoplay muted loop></video>
```

### 4. 字体

**首选系统字体栈**，不内嵌：
```css
font-family: -apple-system, BlinkMacSystemFont, "PingFang SC", "Helvetica Neue", sans-serif;
```

**必须用特定字体**（如衬线、手写体）：
- 从 Google Fonts 下载 woff2
- base64 塞进 `@font-face`

```python
woff2_b64 = base64.b64encode(open('Inter.woff2', 'rb').read()).decode('ascii')
# 写进 style:
# @font-face {
#   font-family: 'Inter';
#   src: url(data:font/woff2;base64,{WOFF2_B64}) format('woff2');
# }
```

单字体 woff2 ≈ 30-80KB。选子集（只中文常用字 + ASCII）可以压到 100KB 以内。

### 5. CSS / JS

全部写在 html 文件的 `<style>` 和 `<script>` 里。**禁止** `<link rel="stylesheet" href="xxx.css">`、`<script src="xxx.js">`。

第三方库（如 p5.js、echarts）：
- ≤ 300KB → 直接内嵌全文
- > 300KB → 用 CDN（仅限该演讲场合稳定有网时）

## 验证自包含

**断网测试**（必跑）：
```bash
# 1. 关闭网络
sudo ifconfig en0 down

# 2. 打开 file:// 协议
open "file:///path/to/presentation.html"

# 3. 翻每一页，检查：
#    - 图片是否全部显示
#    - 音频是否能播放
#    - 字体是否正确
#    - 无控制台红色报错

# 4. 恢复网络
sudo ifconfig en0 up
```

**快速 grep 检查**（无需断网）：
```bash
# 找外部资源引用，应该 0 条
grep -E 'src="http|href="http|url\(http' presentation.html
grep -E 'src="[^d][^a][^t]|href="[^#d]' presentation.html  # src 不是 data:... 开头的

# 这些只应该出现：
#   - data:image/...
#   - data:audio/...
#   - data:font/...
#   - 相对路径（如果刻意保留）
```

## 体积控制

| 总大小 | 评价 | 处理 |
|--------|------|------|
| < 5 MB | 优秀 | - |
| 5-10 MB | 可接受 | 看打开速度 |
| 10-20 MB | 警戒 | 图片压缩、TTS 降码率 |
| > 20 MB | 不可接受 | 拆资源或换视频方案 |

**常见瘦身手段**：
1. PNG → WebP（q=80）
2. TTS mp3 bitrate 128kbps → 96kbps
3. 相同图片多处使用 → 抽成变量复用同一份 base64
4. 大数据图表 → echarts 渲染 + 数据 JSON 内嵌，比 SVG 小

## 脚本工具

见 `scripts/inject-audio.py`、`scripts/embed-images.py`（自动把 HTML 里的 `src="assets/xxx"` 全部替换为 base64）。
