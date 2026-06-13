#!/bin/sh
# 安装 git post-commit 自动推送钩子
# 用法：sh setup-hook.sh

HOOK_DIR=".git/hooks"
HOOK_FILE="$HOOK_DIR/post-commit"

if [ ! -d "$HOOK_DIR" ]; then
    echo "❌ 请在 git 仓库目录下运行此脚本"
    exit 1
fi

cat > "$HOOK_FILE" << 'HOOK'
#!/bin/sh
echo "🔄 自动同步到 GitHub..."
git push origin main 2>&1
HOOK

chmod +x "$HOOK_FILE"
echo "✅ post-commit 自动推送钩子已安装！"
echo "   以后每次 git commit 都会自动 push 到 GitHub。"
