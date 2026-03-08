#!/bin/bash

# 项目初始化脚本
# 在空项目中运行：bash <(curl -s https://raw.githubusercontent.com/.../init_project.sh)
# 或本地运行：bash scripts/init_project.sh

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# 获取脚本所在目录
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_ROOT="$(pwd)"

echo ""
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     Claude Project 初始化                              ║"
echo "║                                                        ║"
echo "║     为你的项目配置开发环境                             ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# GitHub 配置
echo -e "${YELLOW}配置 GitHub 信息${NC}"
echo ""

# 尝试从 git config 获取用户名
GIT_USER=$(git config user.name 2>/dev/null || echo "")
GIT_EMAIL=$(git config user.email 2>/dev/null || echo "")

# 默认 GitHub 用户名为 hufeide
DEFAULT_GH_USER="hufeide"

# 从参数或环境变量获取，或使用 git config 的值，最后使用默认值
GH_USER="${1:-$GITHUB_USER:-$GIT_USER:-$DEFAULT_GH_USER}"
if [ -z "$GH_USER" ]; then
    echo -e "${BLUE}检测到 Git 用户信息:${NC}"
    echo "  用户名：$GIT_USER"
    echo "  邮箱：$GIT_EMAIL"
    echo ""
    echo -e "${YELLOW}提示：使用参数传递：./init_project.sh <github_username>${NC}"
    echo -e "${YELLOW}      或使用环境变量：GITHUB_USER=<username> ./init_project.sh${NC}"
    exit 1
fi

if [ -n "$GIT_USER" ]; then
    echo -e "${BLUE}检测到 Git 用户信息:${NC}"
    echo "  用户名：$GIT_USER"
    echo "  邮箱：$GIT_EMAIL"
    echo ""
fi

echo ""
echo -e "${BLUE}GitHub 用户名：${GREEN}$GH_USER${NC}"
echo ""

# 获取项目名
CURRENT_DIR=$(basename "$PROJECT_ROOT")
PROJECT_NAME="${2:-$PROJECT_NAME:$CURRENT_DIR}"
if [ -z "$PROJECT_NAME" ]; then
    PROJECT_NAME="$CURRENT_DIR"
fi

echo ""
echo -e "${BLUE}项目名：${GREEN}$PROJECT_NAME${NC}"
echo -e "${BLUE}GitHub 路径：${GREEN}https://github.com/$GH_USER/$PROJECT_NAME${NC}"
echo ""

# 获取项目描述
PROJECT_DESC="${3:-$PROJECT_DESC}"
if [ -z "$PROJECT_DESC" ]; then
    PROJECT_DESC="我的项目"
fi
echo ""
echo -e "${BLUE}项目描述：${GREEN}$PROJECT_DESC${NC}"
echo ""

echo -e "${GREEN}✓ 配置已确认${NC}"
echo ""
echo -e "${BLUE}配置摘要:${NC}"
echo "  GitHub 用户名：$GH_USER"
echo "  项目名：$PROJECT_NAME"
echo "  项目描述：$PROJECT_DESC"
echo "  项目路径：https://github.com/$GH_USER/$PROJECT_NAME"
echo ""

# 第一步：创建 config 目录并保存配置信息
echo -e "${YELLOW}第一步：创建项目配置文件...${NC}"
echo ""

# 创建 config 目录
mkdir -p "$PROJECT_ROOT/config"

# 创建 config/project.json - 包含 GitHub 项目信息和账号信息
cat > "$PROJECT_ROOT/config/project.json" << EOF
{
  "github": {
    "user": "$GH_USER",
    "repo": "$PROJECT_NAME",
    "url": "https://github.com/$GH_USER/$PROJECT_NAME",
    "token": ""
  },
  "project": {
    "name": "$PROJECT_NAME",
    "description": "$PROJECT_DESC",
    "default_branch": "main"
  }
}
EOF
echo -e "${GREEN}✓ config/project.json (已创建 - 包含 GitHub 项目地址和账号信息)${NC}"

# 创建 config/permissions.json - 权限配置
cat > "$PROJECT_ROOT/config/permissions.json" << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash:*",
      "Filesystem:*",
      "Git:*",
      "Network:*",
      "Search:*",
      "Edit:*",
      "Read:*",
      "Write:*",
      "Create:*",
      "Run:*"
    ],
    "deny": [
      "Bash:rm",
      "Bash:rm *",
      "Bash:rm -rf",
      "Bash:rm -rf *",
      "Bash:sudo rm",
      "Bash:sudo rm -rf"
    ]
  },
  "Bash": {
    "allowAll": true,
    "denyCommands": [
      "rm",
      "rm -rf",
      "sudo rm",
      "sudo rm -rf"
    ]
  },
  "filesystem": {
    "allowWrite": true,
    "allowDelete": false
  },
  "git": {
    "allowAll": true
  },
  "network": {
    "allowAll": true
  },
  "security": {
    "requireConfirmation": false,
    "sandbox": false
  }
}
EOF
echo -e "${GREEN}✓ config/permissions.json (已创建 - 包含权限配置)${NC}"

echo ""

# 第二步：设置权限（放开所有权限，除了 rm）
echo -e "${YELLOW}第二步：设置权限...${NC}"
echo ""

CLAUDE_DIR="$PROJECT_ROOT/.claude"
SETTINGS_FILE="$CLAUDE_DIR/settings.local.json"

mkdir -p "$CLAUDE_DIR"

if [ ! -f "$SETTINGS_FILE" ]; then
    # 从 config/permissions.json 复制权限配置到 .claude/settings.local.json
    cp "$PROJECT_ROOT/config/permissions.json" "$SETTINGS_FILE"
    echo -e "${GREEN}✓ .claude/settings.local.json (已从 config/permissions.json 复制)${NC}"
else
    # 检查是否需要更新权限
    if ! grep -q '"Bash:\*"' "$SETTINGS_FILE" 2>/dev/null; then
        # 从 config/permissions.json 复制权限配置
        cp "$PROJECT_ROOT/config/permissions.json" "$SETTINGS_FILE"
        echo -e "${GREEN}✓ .claude/settings.local.json (已从 config/permissions.json 更新)${NC}"
    else
        echo -e "${BLUE}  .claude/settings.local.json (已存在)${NC}"
    fi
fi
echo ""

# 检查是否在 git 仓库
if ! git rev-parse --git-dir &> /dev/null; then
    echo -e "${YELLOW}⚠ 当前目录不是 Git 仓库${NC}"
    echo ""
    read -p "是否初始化 Git 仓库？(y/n) " -n 1 -r
    echo ""
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        git init
        git branch -M main
        echo -e "${GREEN}✓ Git 仓库已初始化${NC}"
    fi
    echo ""
else
    # 确保主分支名称正确
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "")
    if [ -n "$CURRENT_BRANCH" ] && [ "$CURRENT_BRANCH" != "main" ] && [ "$CURRENT_BRANCH" != "master" ]; then
        echo -e "${YELLOW}⚠ 当前分支不是 main 或 master${NC}"
        echo -e "${BLUE}  当前分支：$CURRENT_BRANCH${NC}"
    fi

    # 配置远程仓库 URL（从 config/project.json 获取）
    echo -e "${YELLOW}配置远程仓库...${NC}"

    # 从 config/project.json 读取 URL
    if [ -f "$PROJECT_ROOT/config/project.json" ]; then
        GITHUB_URL=$(grep '"url"' "$PROJECT_ROOT/config/project.json" | head -1 | cut -d'"' -f4)
        # 移除 .git 后缀（如果存在）
        GITHUB_URL=$(echo "$GITHUB_URL" | sed 's/\.git$//')
    else
        # 默认 URL
        GITHUB_URL="https://github.com/$GH_USER/$PROJECT_NAME"
    fi

    # 检查是否已有 remote
    if git remote get-url origin &> /dev/null; then
        # 更新现有的 origin
        git remote set-url origin "$GITHUB_URL"
        echo -e "${GREEN}✓ 远程仓库已更新：$GITHUB_URL${NC}"
    else
        # 添加新的 remote
        git remote add origin "$GITHUB_URL"
        echo -e "${GREEN}✓ 远程仓库已添加：$GITHUB_URL${NC}"
    fi
fi

# 创建项目结构
echo -e "${YELLOW}创建项目结构...${NC}"
echo ""

# config 目录已在第一步创建
mkdir -p docs/plans
mkdir -p docs/decisions
mkdir -p scripts
mkdir -p src
mkdir -p tests

# 创建 config/env.json (环境配置，保留向后兼容)
if [ ! -f "$PROJECT_ROOT/config/env.json" ]; then
    cat > "$PROJECT_ROOT/config/env.json" << EOF
{
  "PROJECT_NAME": "$PROJECT_NAME",
  "PROJECT_DESCRIPTION": "$PROJECT_DESC",
  "DATABASE_URL": "mongodb://localhost:27017/mydb",
  "MODEL": "claude-v1"
}
EOF
    echo -e "${GREEN}✓ config/env.json (已创建 - 环境配置)${NC}"
else
    echo -e "${BLUE}  config/env.json (已存在)${NC}"
fi

# 创建 CLAUDE.md
if [ ! -f "$PROJECT_ROOT/CLAUDE.md" ]; then
    cat > "$PROJECT_ROOT/CLAUDE.md" << 'EOF'
# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## 项目概述

在此描述你的项目。

## 技术栈

- 前端：...
- 后端：...
- 数据库：...

## 开发命令

```bash
# 安装依赖
npm install

# 运行开发服务器
npm run dev

# 运行测试
npm test

# 运行 lint
npm run lint
```

## 项目结构

```
src/
├── components/   # React 组件
├── pages/        # 页面
├── utils/        # 工具函数
└── styles/       # 样式文件
```

## 强制工作流程

**重要：** 必须按照以下顺序执行，不可跳过任何步骤：

### 阶段 1: 需求探索（必须首先执行）
```
/brainstorming
```
- 与用户讨论需求
- 确定功能列表
- 确认技术选型

### 阶段 2: 创建计划（必须在写代码前执行）
```
/writing-plans
```
- 创建详细的实施计划文档
- 计划文档保存在 `docs/plans/` 目录
- **没有 plan 文档，不允许开始写代码**

### 阶段 3: 创建分支
```
/using-git-worktrees
```
- 为功能创建独立的工作分支

### 阶段 4: 实现功能
- 根据 plan 文档逐步实现
- 使用 `/test-driven-development` 编写测试

### 阶段 5: 验证完成
```
/verification-before-completion
```
- 验证所有功能正常工作
- 确保测试通过

### 阶段 6: 合并代码
```
/finishing-a-development-branch
```
- 创建 Pull Request
- 完成代码审查
EOF
    echo -e "${GREEN}✓ CLAUDE.md${NC}"
else
    echo -e "${BLUE}  CLAUDE.md (已存在)${NC}"
fi

# 创建 README.md
if [ ! -f "$PROJECT_ROOT/README.md" ]; then
    cat > "$PROJECT_ROOT/README.md" << 'EOF'
# 项目名称

项目描述。

## 快速开始

```bash
npm install
npm run dev
```

## 开发

参考 `docs/development_workflow.md`
EOF
    echo -e "${GREEN}✓ README.md${NC}"
else
    echo -e "${BLUE}  README.md (已存在)${NC}"
fi

# 创建 .gitignore
if [ ! -f "$PROJECT_ROOT/.gitignore" ]; then
    cat > "$PROJECT_ROOT/.gitignore" << 'EOF'
node_modules/
dist/
*.log
.env
.env.local
.DS_Store

# Claude Project 状态文件（可选追踪）
.guide_state
.guide_history
.todos

# 源代码目录（可选，如果希望追踪代码则删除）
# src/
# tests/
EOF
    echo -e "${GREEN}✓ .gitignore${NC}"
else
    echo -e "${BLUE}  .gitignore (已存在)${NC}"
fi

echo ""

# 初始化状态文件
cat > "$PROJECT_ROOT/.guide_state" << 'EOF'
CURRENT_STAGE="brainstorming"
LAST_ACTIVITY="项目初始化完成，等待需求探索"
REQUIRES_PLAN="true"
EOF
echo -e "${GREEN}✓ .guide_state${NC}"

# 初始化历史记录文件
cat > "$PROJECT_ROOT/.guide_history" << EOF
[$(date "+%Y-%m-%d %H:%M:%S")] init - 项目初始化开始
EOF
echo -e "${GREEN}✓ .guide_history${NC}"

echo ""

# 总结
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     项目初始化完成！                                   ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}下一步:${NC}"
echo ""
echo "1. 编辑 config/env.json，填入你的 GITHUB_TOKEN:"
echo -e "   ${BLUE}https://github.com/settings/tokens${NC}"
echo ""
echo "2. 运行完整检查:"
echo -e "   ${BLUE}bash scripts/check_setup.sh${NC}"
echo ""
echo "3. 开始项目开发:"
echo -e "   ${BLUE}/brainstorming${NC}"
echo ""
echo "4. 查看文档:"
echo "   docs/GUIDE.md - 完整开发引导"
echo "   docs/development_workflow.md - 工作流程说明"
echo ""
echo -e "${BLUE}已配置信息:${NC}"
echo "  GitHub: $GH_USER"
echo "  项目：$PROJECT_NAME"
echo "  描述：$PROJECT_DESC"
echo "  地址：https://github.com/$GH_USER/$PROJECT_NAME"
echo ""
echo -e "${YELLOW}⚠ 需要手动设置的环境信息:${NC}"
echo ""
echo "  1. GITHUB_TOKEN - 用于 GitHub API 访问"
echo "     获取地址：https://github.com/settings/tokens"
echo "     设置位置：config/project.json (github.token)"
echo ""
echo "  2. 项目用户信息 - Git 配置"
echo "     运行：git config user.name '你的用户名'"
echo "     运行：git config user.email '你的邮箱'"
echo ""
echo -e "${BLUE}配置文件说明:${NC}"
echo "  config/project.json    - GitHub 项目信息和账号信息"
echo "  config/permissions.json - Claude 权限配置"
echo "  config/env.json        - 环境配置 (向后兼容)"
echo ""