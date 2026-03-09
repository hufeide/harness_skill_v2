#!/bin/bash

# Git 提交和推送脚本
# 从 config/project.json 读取 GitHub 仓库地址并推送

# 颜色
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

PROJECT_ROOT="$(pwd)"

# 美化标题
echo -e "\n${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     Git 提交和推送                                     ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"

# 检查 config/project.json 是否存在
if [ ! -f "$PROJECT_ROOT/config/project.json" ]; then
    echo -e "${RED}错误：未找到 config/project.json${NC}\n"
    echo -e "${YELLOW}请先运行项目初始化：${NC}"
    echo "  /harness_skill 初始化和引导"
    echo ""
    exit 1
fi

# 检查 jq 是否可用
if ! command -v jq >/dev/null 2>&1; then
    echo -e "${RED}错误：请安装 jq 用于解析 JSON${NC}"
    exit 1
fi

# 从 JSON 中读取 GitHub URL
GITHUB_URL=$(jq -r '.github.url' "$PROJECT_ROOT/config/project.json")
if [ -z "$GITHUB_URL" ] || [ "$GITHUB_URL" == "null" ]; then
    echo -e "${RED}错误：无法从 config/project.json 读取 GitHub URL${NC}"
    exit 1
fi
# 移除 .git 后缀
GITHUB_URL="${GITHUB_URL%.git}"

echo -e "${BLUE}GitHub 仓库：${GREEN}$GITHUB_URL${NC}\n"

# 初始化 Git 仓库（如果尚未初始化）
NEEDS_INIT=false
if [ ! -d "$PROJECT_ROOT/.git" ]; then
    echo -e "${YELLOW}⚠ 当前目录不是 Git 仓库，正在初始化...${NC}"
    git init
    NEEDS_INIT=true
    echo -e "${GREEN}✓ Git 仓库已初始化${NC}\n"
fi

# 检查是否有未提交的更改（包括新文件）
HAS_UNCOMMITTED=false
if ! git diff --quiet 2>/dev/null; then
    HAS_UNCOMMITTED=true
fi
if ! git diff --cached --quiet 2>/dev/null; then
    HAS_UNCOMMITTED=true
fi
# 检查是否有未追踪的文件
if [ -n "$(git ls-files --others --exclude-standard 2>/dev/null)" ]; then
    HAS_UNCOMMITTED=true
fi

# 如果有更改或刚初始化，暂存所有文件
if [ "$HAS_UNCOMMITTED" = true ] || [ "$NEEDS_INIT" = true ]; then
    git add .
    echo -e "${GREEN}✓ 文件已暂存${NC}"

    # 检查是否有可提交的内容
    if ! git diff --cached --quiet 2>/dev/null; then
        echo -e "${BLUE}请输入提交信息（或直接回车使用默认信息）:${NC}"
        read -r COMMIT_MSG
        COMMIT_MSG=${COMMIT_MSG:-update}

        git commit -m "$COMMIT_MSG"
        echo -e "${GREEN}✓ 提交已创建${NC}"
    else
        echo -e "${YELLOW}⚠ 没有可提交的内容${NC}"
    fi
else
    echo -e "${BLUE}没有需要提交的更改${NC}"
fi

# 确保在 main 分支
git branch -M main 2>/dev/null
echo -e "${GREEN}✓ 分支已设置为 main${NC}"

# 配置远程仓库
if git remote get-url origin >/dev/null 2>&1; then
    git remote set-url origin "$GITHUB_URL"
    echo -e "${GREEN}✓ 远程仓库已更新：$GITHUB_URL${NC}"
else
    git remote add origin "$GITHUB_URL"
    echo -e "${GREEN}✓ 远程仓库已添加：$GITHUB_URL${NC}"
fi

# 配置代理（如果有 .git_proxy）
GIT_PROXY=""
if [ -f "$PROJECT_ROOT/.git_proxy" ]; then
    PROXY_HOST=$(grep "host" "$PROJECT_ROOT/.git_proxy" | cut -d'=' -f2 | tr -d ' ')
    PROXY_PORT=$(grep "port" "$PROJECT_ROOT/.git_proxy" | cut -d'=' -f2 | tr -d ' ')
    if [ -n "$PROXY_HOST" ] && [ -n "$PROXY_PORT" ]; then
        GIT_PROXY="socks5://${PROXY_HOST}:${PROXY_PORT}"
        echo -e "${GREEN}✓ 代理已配置：${PROXY_HOST}:${PROXY_PORT}${NC}"
    fi
fi

# 检查是否有本地提交
LOCAL_COMMITS=$(git rev-list --count HEAD 2>/dev/null || echo "0")
if [ "$LOCAL_COMMITS" -eq 0 ]; then
    echo -e "${YELLOW}⚠ 没有本地提交，无法推送${NC}"
    echo ""
    echo -e "${BLUE}提示：请创建一些文件并再次运行此脚本${NC}"
    exit 0
fi

# 推送
echo -e "${YELLOW}推送到 GitHub...${NC}"
if ! git -c http.proxy="$GIT_PROXY" -c https.proxy="$GIT_PROXY" push -u origin main 2>&1 | tee /tmp/git_push.log; then
    echo -e "${RED}推送失败，请检查日志：${NC}"
    cat /tmp/git_push.log
    echo ""
    echo -e "${YELLOW}提示：检查以下内容${NC}"
    echo "  1. GitHub 仓库是否存在"
    echo "  2. 是否有 GitHub 访问权限"
    echo "  3. 网络连接是否正常"
    echo "  4. 是否需要配置 .git_proxy 代理文件"
    exit 1
fi

echo -e "\n${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     推送成功！                                         ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}\n"
echo -e "${GREEN}仓库地址：$GITHUB_URL${NC}"
echo -e "${BLUE}访问：$GITHUB_URL${NC}\n"