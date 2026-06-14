#!/bin/bash
# 生物+地理口袋手卡 - GitHub Pages 一键部署脚本
# 使用方法：
#   bash deploy.sh

set -e

REPO_NAME="bio-geo-flashcards"
USERNAME="flyingbluegithub"
REMOTE_URL="https://github.com/${USERNAME}/${REPO_NAME}.git"

echo "========================================="
echo "  生物+地理口袋手卡 - GitHub 部署"
echo "========================================="
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

echo "🌐 配置 GitHub 远程仓库..."
git remote remove origin 2>/dev/null || true
git remote add origin ${REMOTE_URL}
echo "✅ 远程仓库：https://github.com/${USERNAME}/${REPO_NAME}"
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
# 忽略本机可能存在的 GitHub URL 改写，直接推送到 github.com。
GIT_CONFIG_GLOBAL=/dev/null git push -u origin main
echo "✅ 推送完成"
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
