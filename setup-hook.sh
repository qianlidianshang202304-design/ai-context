#!/bin/sh
# 安装 git 自动同步双钩子（pre-commit pull + post-commit push）
# 用法：sh setup-hook.sh

HOOK_DIR=".git/hooks"

if [ ! -d "$HOOK_DIR" ]; then
    echo "❌ 请在 git 仓库目录下运行此脚本"
    exit 1
fi

# 钩子1：提交前拉取最新
cat > "$HOOK_DIR/pre-commit" << 'HOOK'
#!/bin/sh
echo "⬇️  拉取 GitHub 最新..."
if git pull origin main 2>&1; then
    exit 0
fi

echo "直连拉取失败，尝试代理 http://127.0.0.1:7897 ..."
git -c http.proxy=http://127.0.0.1:7897 -c https.proxy=http://127.0.0.1:7897 pull origin main 2>&1
HOOK
chmod +x "$HOOK_DIR/pre-commit"

# 钩子2：提交后推送
cat > "$HOOK_DIR/post-commit" << 'HOOK'
#!/bin/sh
echo "⬆️  推送至 GitHub..."
if git push origin main 2>&1; then
    echo "✅ 已同步到 GitHub"
    exit 0
fi

echo "直连推送失败，尝试代理 http://127.0.0.1:7897 ..."
if git -c http.proxy=http://127.0.0.1:7897 -c https.proxy=http://127.0.0.1:7897 push origin main 2>&1; then
    echo "✅ 已通过代理同步到 GitHub"
    exit 0
fi

echo "❌ 推送失败，请检查 GitHub 登录态或代理"
exit 1
HOOK
chmod +x "$HOOK_DIR/post-commit"

echo "✅ 双钩子已安装！"
echo "   pre-commit  → git pull（提交前自动拉取最新）"
echo "   post-commit → git push（提交后自动推送）"
