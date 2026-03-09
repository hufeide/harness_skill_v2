#!/bin/bash

# Claude Project Quick Start Script
# 引导用户从零开始配置项目

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

echo ""
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     Claude Project 快速配置向导                        ║"
echo "║                                                        ║"
echo "║     带你从零开始配置开发环境                           ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""

# 步骤 1: 检查 Claude Code CLI
echo -e "${YELLOW}[步骤 1/6] 检查 Claude Code CLI${NC}"
if ! command -v claude &> /dev/null; then
    echo -e "${RED}✗ Claude Code CLI 未安装${NC}"
    echo ""
    echo "请运行以下命令安装:"
    echo -e "  ${BLUE}npm install -g @anthropic-ai/claude-code${NC}"
    echo ""
    read -p "按回车键继续..."
else
    echo -e "${GREEN}✓ Claude Code CLI 已安装${NC}"
fi
echo ""

# 步骤 2: 安装核心技能
echo -e "${YELLOW}[步骤 2/6] 安装核心技能${NC}"
echo ""
echo "正在检查核心技能..."
echo ""

SKILLS=(
    "brainstorming"
    "writing-plans"
    "test-driven-development"
    "systematic-debugging"
    "using-git-worktrees"
    "requesting-code-review"
    "verification-before-completion"
)

for skill in "${SKILLS[@]}"; do
    if [ -d "$HOME/.agents/skills/$skill" ] || [ -L "$HOME/.claude/skills/$skill" ]; then
        echo -e "  ${GREEN}✓ $skill${NC}"
    else
        echo -e "  ${YELLOW}✗ $skill (需要安装)${NC}"
    fi
done

echo ""
echo -e "${BLUE}提示:${NC} 如果缺少技能，运行:"
echo -e "  ${BLUE}npx skills add brainstorming writing-plans test-driven-development systematic-debugging using-git-worktrees requesting-code-review verification-before-completion${NC}"
echo ""
read -p "按回车键继续..."
echo ""

# 步骤 3: 安装插件
echo -e "${YELLOW}[步骤 3/6] 检查插件${NC}"
echo ""

if [ -f "$HOME/.claude/plugins/installed_plugins.json" ]; then
    if grep -q "feature-dev" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
        echo -e "  ${GREEN}✓ feature-dev${NC}"
    else
        echo -e "  ${YELLOW}✗ feature-dev (需要安装)${NC}"
    fi

    if grep -q "compound-engineering" "$HOME/.claude/plugins/installed_plugins.json" 2>/dev/null; then
        echo -e "  ${GREEN}✓ compound-engineering${NC}"
    else
        echo -e "  ${YELLOW}✗ compound-engineering (需要安装)${NC}"
    fi
else
    echo -e "  ${YELLOW}✗ 插件配置文件不存在${NC}"
fi

echo ""
echo -e "${BLUE}提示:${NC} 如果缺少插件，运行:"
echo -e "  ${BLUE}bash scripts/setup_plugins.sh${NC}"
echo ""
read -p "按回车键继续..."
echo ""

# 步骤 4: 配置 Hooks
echo -e "${YELLOW}[步骤 4/6] 配置 Hooks${NC}"
echo ""

if [ -f "$HOME/.claude/hooks/pre_commit" ] && [ -f "$HOME/.claude/hooks/post_commit" ]; then
    echo -e "${GREEN}✓ Hooks 已配置${NC}"
else
    echo -e "${YELLOW}正在配置 Hooks...${NC}"
    bash scripts/setup_hooks.sh
    echo ""
fi
echo ""
read -p "按回车键继续..."
echo ""

# 步骤 5: 配置项目文件
echo -e "${YELLOW}[步骤 5/6] 配置项目文件${NC}"
echo ""

# 创建必要的目录
mkdir -p config docs/plans docs/decisions src tests scripts

# 检查 env.json
if [ ! -f "config/env.json" ]; then
    echo -e "${YELLOW}创建 config/env.json...${NC}"
    cat > config/env.json << 'EOF'
{
  "PROJECT_NAME": "my-project",
  "GITHUB_TOKEN": "",
  "DATABASE_URL": "mongodb://localhost:27017/mydb",
  "MODEL": "claude-v1",
  "DEFAULT_BRANCH": "main"
}
EOF
    echo -e "${GREEN}✓ 已创建 config/env.json${NC}"
    echo -e "${YELLOW}提示：请编辑 config/env.json，填入你的 GITHUB_TOKEN${NC}"
else
    echo -e "${GREEN}✓ config/env.json 已存在${NC}"
fi

# 检查 CLAUDE.md
if [ ! -f "CLAUDE.md" ]; then
    echo -e "${YELLOW}创建 CLAUDE.md...${NC}"
    cat > CLAUDE.md << 'EOF'
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

## 工作流

1. 使用 `/brainstorming` 开始需求分析
2. 使用 `/writing-plans` 创建实施计划
3. 使用 `/using-git-worktrees` 创建功能分支
4. 开发完成后使用 `/verification-before-completion` 验证
5. 使用 `/finishing-a-development-branch` 创建 PR
EOF
    echo -e "${GREEN}✓ 已创建 CLAUDE.md${NC}"
else
    echo -e "${GREEN}✓ CLAUDE.md 已存在${NC}"
fi

# 检查 docs 目录
if [ ! -d "docs" ]; then
    mkdir -p docs/plans docs/decisions
    echo -e "${GREEN}✓ 创建 docs 目录${NC}"
fi

echo ""
read -p "按回车键继续..."
echo ""

# 步骤 6: 初始化 Git
echo -e "${YELLOW}[步骤 6/6] 检查 Git 仓库${NC}"
echo ""

if ! git rev-parse --git-dir &> /dev/null; then
    echo -e "${YELLOW}初始化 Git 仓库...${NC}"
    git init
    git branch -M main
    echo -e "${GREEN}✓ Git 仓库已初始化${NC}"
    echo ""
    echo -e "${BLUE}下一步:${NC}"
    echo "  git add ."
    echo "  git commit -m 'Initial commit'"
else
    echo -e "${GREEN}✓ Git 仓库已存在${NC}"
    echo -e "  当前分支：$(git branch --show-current)"
fi

echo ""
read -p "按回车键继续..."
echo ""

# 完成
echo -e "${CYAN}"
echo "╔════════════════════════════════════════════════════════╗"
echo "║                                                        ║"
echo "║     配置完成！                                         ║"
echo "║                                                        ║"
echo "╚════════════════════════════════════════════════════════╝"
echo -e "${NC}"
echo ""
echo -e "${GREEN}下一步:${NC}"
echo ""
echo "1. 运行完整检查:"
echo -e "   ${BLUE}bash scripts/check_setup.sh${NC}"
echo ""
echo "2. 开始项目开发:"
echo -e "   ${BLUE}/brainstorming${NC}"
echo ""
echo "3. 查看文档:"
echo -e "   docs/development_workflow.md - 完整工作流程"
echo -e "   docs/testing.md - 测试文档"
echo ""