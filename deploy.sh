#!/bin/bash
# 生物+地理口袋手卡 - GitHub Pages 一键部署脚本
# 使用方法：
#   1. 先运行 `gh auth login` 完成 GitHub 登录
#   2. 运行 `bash deploy.sh` 即可

set -e

REPO_NAME="bio-geo-flashcards"
USERNAME="flyingbluegithub"
REMOTE_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

echo "========================================="
echo "  生物+地理口袋手卡 - GitHub 部署"
echo "========================================="
echo ""

# 检查 gh CLI 是否安装
if ! command -v gh &> /dev/null; then
    echo "❌ 未找到 gh CLI，请先安装：brew install gh"
    exit 1
fi

# 检查 gh 是否已登录
echo "🔍 检查 GitHub 登录状态..."
if ! gh auth status &> /dev/null; then
    echo "❌ 尚未登录 GitHub，请先运行："
    echo "   gh auth login"
    echo "   选择 GitHub.com → HTTPS → Login with a web browser"
    exit 1
fi
echo "✅ GitHub 已登录"
echo ""

# 进入脚本所在目录
cd "$(dirname "$0")"

# 初始化 Git 仓库（如果还没有）
if [ ! -d ".git" ]; then
    echo "📦 初始化 Git 仓库..."
    git init
    git branch -M main
    echo "✅ Git 仓库初始化完成"
else
    echo "✅ Git 仓库已存在"
fi
echo ""

# 创建 .gitignore
if [ ! -f ".gitignore" ]; then
    echo "node_modules/" > .gitignore
    echo ".DS_Store" >> .gitignore
    echo "✅ .gitignore 已创建"
fi

# 检查远程仓库是否已存在
echo "🌐 检查 GitHub 远程仓库..."
if gh repo view ${USERNAME}/${REPO_NAME} &> /dev/null; then
    echo "✅ 远程仓库已存在：https://github.com/${USERNAME}/${REPO_NAME}"
    # 设置远程地址
    git remote remove origin 2>/dev/null || true
    git remote add origin ${REMOTE_URL}
else
    echo "📝 创建新的 GitHub 仓库：${REPO_NAME}"
    gh repo create ${USERNAME}/${REPO_NAME} \
        --public \
        --source=. \
        --push \
        --description "生物+地理会考口袋手卡 - 交互式复习工具" || {
        # 如果创建失败（仓库已存在），直接设置 remote 并 push
        echo "⚠️  创建失败，尝试直接 push..."
        git remote remove origin 2>/dev/null || true
        git remote add origin ${REMOTE_URL}
    }
fi
echo ""

# 添加文件并提交
echo "📝 添加文件并提交..."
git add --all
if git diff --cached --quiet; then
    echo "ℹ️  没有新变更需要提交"
else
    git commit -m "部署：生物+地理口袋手卡 v1.0"
    echo "✅ 提交完成"
fi
echo ""

# Push 到 GitHub
echo "🚀 推送到 GitHub..."
git push -u origin main
echo "✅ 推送完成"
echo ""

# 启用 GitHub Pages
echo "🌍 启用 GitHub Pages..."
gh repo edit ${USERNAME}/${REPO_NAME} --enable-pages --pages-source-branch main --pages-source-path "/" 2>/dev/null || {
    echo "⚠️  自动启用 Pages 失败，请手动在 GitHub 仓库设置中启用："
    echo "   ${REPO_NAME} → Settings → Pages → Source: main / (root)"
}
echo ""

echo "========================================="
echo "  🎉 部署完成！"
echo "========================================="
echo ""
echo "📱 访问地址："
echo "   https://study.aoutech.uk/"
echo ""
echo "📦 仓库地址："
echo "   https://github.com/${USERNAME}/${REPO_NAME}"
echo ""
echo "💡 提示：GitHub Pages 首次部署需要 1-2 分钟生效"
echo "   如果访问 404，请稍等片刻再刷新"
echo ""
