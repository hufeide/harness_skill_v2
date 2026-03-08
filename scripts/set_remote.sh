#!/bin/bash

# 设置 Git 远程仓库 URL（从 config/project.json 读取）
# 用法：./set_remote.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_ROOT="$(pwd)"
CONFIG_FILE="$PROJECT_ROOT/config/project.json"

echo ""
echo -e "${CYAN}配置 Git 远程仓库${NC}"
echo ""

# 检查配置文件是否存在
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${RED}✗ 配置文件不存在：$CONFIG_FILE${NC}"
    echo "请先运行项目初始化：bash scripts/init_project.sh"
    exit 1
fi

# 从配置文件读取 URL
GITHUB_URL=$(grep '"url"' "$CONFIG_FILE" | head -1 | cut -d'"' -f4)

# 清理 URL（移除 .git 后缀）
GITHUB_URL=$(echo "$GITHUB_URL" | sed 's/\.git$//')

if [ -z "$GITHUB_URL" ]; then
    echo -e "${RED}✗ 无法从配置文件中读取 GitHub URL${NC}"
    exit 1
fi

echo -e "${BLUE}检测到的配置:${NC}"
echo "  GitHub URL: $GITHUB_URL"
echo ""

# 检查是否有远程仓库
if git remote get-url origin &> /dev/null; then
    CURRENT_URL=$(git remote get-url origin)
    echo -e "${BLUE}当前远程 URL:${NC} $CURRENT_URL"

    if [ "$CURRENT_URL" != "$GITHUB_URL" ]; then
        echo -e "${YELLOW}远程 URL 不匹配，正在更新...${NC}"
        git remote set-url origin "$GITHUB_URL"
        echo -e "${GREEN}✓ 远程仓库已更新：$GITHUB_URL${NC}"
    else
        echo -e "${GREEN}✓ 远程仓库已正确配置：$GITHUB_URL${NC}"
    fi
else
    echo -e "${YELLOW}未配置远程仓库，正在添加...${NC}"
    git remote add origin "$GITHUB_URL"
    echo -e "${GREEN}✓ 远程仓库已添加：$GITHUB_URL${NC}"
fi

echo ""
echo -e "${GREEN}完成！现在可以运行：git push -u origin main${NC}"
echo ""