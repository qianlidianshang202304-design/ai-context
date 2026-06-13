#!/bin/sh
# AI Context 推送到 GitHub（通过 Clash 代理）
cd ~/Documents/GitHub/ai-context

echo "📤 正在通过代理推送 ai-context 到 GitHub..."

# 临时配置代理
git config http.proxy http://127.0.0.1:7897
git config https.proxy http://127.0.0.1:7897

git push -u origin main

# 推送完成后取消代理（避免影响其他仓库）
git config --unset http.proxy
git config --unset https.proxy

if [ $? -eq 0 ]; then
    echo ""
    echo "✅ 推送成功！"
    echo "   仓库地址: https://github.com/qianlidianshang202304-design/ai-context"
    echo ""
    echo "🔁 自动同步已启用：以后每次 git commit 都会自动 push。"
else
    echo "❌ 推送失败，请检查网络或 Token。"
fi
