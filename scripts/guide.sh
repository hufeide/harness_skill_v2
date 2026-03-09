#!/bin/bash

# Claude Project Guide - 智能引导系统
# 主动引导用户完成项目开发和最佳实践

set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
MAGENTA='\033[0;35m'
NC='\033[0m'

PROJECT_ROOT="$(pwd)"
GUIDE_STATE_FILE="$PROJECT_ROOT/.guide_state"
GUIDE_HISTORY_FILE="$PROJECT_ROOT/.guide_history"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 更新项目状态
update_project_state() {
    local stage="$1"
    local activity="$2"

    if [ -n "$stage" ] && [ -n "$activity" ]; then
        # 更新 .guide_state
        cat > "$GUIDE_STATE_FILE" << EOF
CURRENT_STAGE="$stage"
LAST_ACTIVITY="$activity"
EOF

        # 更新 .guide_history
        local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
        echo "[$timestamp] $stage - $activity" >> "$GUIDE_HISTORY_FILE"

        echo -e "${GREEN}✓ 状态已更新：$stage - $activity${NC}"
    fi
}

# 显示欢迎信息
show_welcome() {
    echo ""
    echo -e "${CYAN}"
    echo "╔════════════════════════════════════════════════════════╗"
    echo "║                                                        ║"
    echo "║     👋 欢迎使用 Claude Project Guide                   ║"
    echo "║                                                        ║"
    echo "║     我是你的开发领路人，会带你完成整个开发流程         ║"
    echo "║                                                        ║"
    echo "╚════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
    echo ""
}

# 根据阶段获取活动描述
get_stage_activity() {
    local stage="$1"
    case "$stage" in
        "init") echo "项目初始化" ;;
        "planning") echo "需求分析和设计" ;;
        "tasks") echo "任务规划" ;;
        "development") echo "开发中" ;;
        "testing") echo "代码已写完，等待测试" ;;
        "verify") echo "待验证和上传" ;;
        "ready") echo "准备就绪，等待推送" ;;
        "completed") echo "已完成并推送到远程" ;;
        *) echo "未知活动" ;;
    esac
}

# 检查是否有源代码
has_source_code() {
    local has_code=false

    # 检查 src 目录
    if [ -d "$PROJECT_ROOT/src" ]; then
        if [ -n "$(find $PROJECT_ROOT/src -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rb' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.html' -o -name '*.css' -o -name '*.vue' -o -name '*.svelte' \) 2>/dev/null)" ]; then
            has_code=true
        fi
    fi

    # 检查根目录
    if [ "$has_code" = false ] && [ -n "$(find $PROJECT_ROOT -maxdepth 1 -type f \( -name '*.js' -o -name '*.html' -o -name '*.css' -o -name '*.py' -o -name '*.rb' \) 2>/dev/null)" ]; then
        has_code=true
    fi

    echo "$has_code"
}

# 显示当前状态
show_status() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  当前项目状态${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""

    # 自动生成项目状态
    local stage=$(check_project_stage)
    local activity=$(get_stage_activity "$stage")

    # 自动更新状态文件
    update_project_state "$stage" "$activity"

    echo -e "当前阶段：${GREEN}${stage}${NC}"
    echo -e "最后活动：${GREEN}${activity}${NC}"

    echo ""
    echo -e "待办任务：${GREEN}$(todo_count)${NC} 个"
    echo -e "最近提交：${GREEN}$(git log -1 --oneline 2>/dev/null || echo '无')${NC}"
    echo ""

    # 如果有源代码且 README 存在，检查是否需要更新
    local has_code=$(has_source_code)
    if [ "$has_code" = "true" ] && [ -f "$PROJECT_ROOT/README.md" ]; then
        # 检查 README 是否是默认模板
        if grep -q "项目名称" "$PROJECT_ROOT/README.md" 2>/dev/null; then
            if [ -f "$SCRIPT_DIR/update_readme.sh" ]; then
                echo -e "${BLUE}更新项目文档...${NC}"
                bash "$SCRIPT_DIR/update_readme.sh"
            fi
        fi
    fi

    # 如果是 verify 或 completed 阶段，也更新 README
    if [ "$stage" = "verify" ] || [ "$stage" = "ready" ] || [ "$stage" = "completed" ]; then
        if [ -f "$SCRIPT_DIR/update_readme.sh" ]; then
            echo -e "${BLUE}更新项目文档...${NC}"
            bash "$SCRIPT_DIR/update_readme.sh"
        fi
    fi
}

# 检查项目阶段并给出建议（完全自动检测）
check_project_stage() {
    local has_code=false
    local has_tests=false

    # 检查是否已初始化
    if [ ! -f "$PROJECT_ROOT/config/env.json" ]; then
        echo "init"
        return
    fi

    # 检查是否有设计文档
    if [ ! -d "$PROJECT_ROOT/docs/plans" ] || [ -z "$(ls -A $PROJECT_ROOT/docs/plans 2>/dev/null)" ]; then
        echo "planning"
        return
    fi

    # 检查是否有代码 (优先 src 目录，其次根目录)
    if [ -d "$PROJECT_ROOT/src" ]; then
        # src 目录下查找各种代码文件（包括 HTML/CSS）
        if [ -n "$(find $PROJECT_ROOT/src -maxdepth 1 -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rb' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.html' -o -name '*.css' -o -name '*.vue' -o -name '*.svelte' \) 2>/dev/null)" ]; then
            has_code=true
        fi
        # 也检查 src 子目录
        if [ "$has_code" = false ] && [ -n "$(find $PROJECT_ROOT/src -type f \( -name '*.js' -o -name '*.ts' -o -name '*.py' -o -name '*.rb' -o -name '*.jsx' -o -name '*.tsx' -o -name '*.html' -o -name '*.css' -o -name '*.vue' -o -name '*.svelte' \) 2>/dev/null)" ]; then
            has_code=true
        fi
    fi
    # 根目录查找
    if [ "$has_code" = false ] && [ -n "$(find $PROJECT_ROOT -maxdepth 1 -type f \( -name '*.js' -o -name '*.html' -o -name '*.css' -o -name '*.py' -o -name '*.rb' \) 2>/dev/null)" ]; then
        has_code=true
    fi

    # 检查是否有测试
    if [ -d "$PROJECT_ROOT/tests" ] && [ -n "$(ls -A $PROJECT_ROOT/tests 2>/dev/null)" ]; then
        has_tests=true
    fi

    # 根据代码和测试情况决定阶段
    if [ "$has_code" = true ]; then
        if [ "$has_tests" = true ]; then
            # 有代码和测试，检查是否已推送到远程
            cd "$PROJECT_ROOT"
            if git remote -v 2>/dev/null | grep -q origin; then
                echo "completed"
            else
                echo "ready"
            fi
        else
            # 有代码但没有测试，检查是否可以上传
            cd "$PROJECT_ROOT"
            if git remote -v 2>/dev/null | grep -q origin; then
                # 有远程仓库，可以验证并上传
                echo "verify"
            else
                echo "testing"
            fi
        fi
        return
    fi

    # 没有代码，检查是否有任务
    if [ ! -f "$PROJECT_ROOT/.todos" ] || [ -z "$(cat $PROJECT_ROOT/.todos 2>/dev/null)" ]; then
        echo "tasks"
    else
        echo "development"
    fi
}

# 显示阶段建议
show_stage_recommendation() {
    local stage=$(check_project_stage)

    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  下一步建议${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""

    case "$stage" in
        "init")
            echo -e "${YELLOW}📋 阶段：项目初始化${NC}"
            echo ""
            echo "你的项目还没有初始化。让我帮你完成："
            echo ""
            echo "  1. 配置项目信息"
            echo "  2. 创建基本文件结构"
            echo "  3. 设置开发环境"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 编辑 config/env.json，填入你的项目名称和 GITHUB_TOKEN"
            echo "  2. 运行：bash scripts/setup_hooks.sh"
            echo ""
            ;;

        "planning")
            echo -e "${YELLOW}📝 阶段：需求规划${NC}"
            echo ""
            echo "项目已初始化，现在需要明确要做什么。"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  运行：/brainstorming"
            echo ""
            echo "这会帮你："
            echo "  • 明确项目目标和需求"
            echo "  • 提出 2-3 种实现方案"
            echo "  • 生成设计文档"
            echo ""
            ;;

        "tasks")
            echo -e "${YELLOW}✅ 阶段：任务规划${NC}"
            echo ""
            echo "设计已完成，现在需要拆解任务。"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  运行：/writing-plans"
            echo ""
            echo "或者手动创建任务："
            echo "  /todos create '任务 1'"
            echo "  /todos create '任务 2'"
            echo ""
            ;;

        "development")
            echo -e "${YELLOW}💻 阶段：开发中${NC}"
            echo ""
            echo "开始开发功能了！"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 创建功能分支：/using-git-worktrees"
            echo "  2. 开始开发功能"
            echo "  3. 完成后：/requesting-code-review"
            echo ""
            echo -e "${BLUE}💡 最佳实践:${NC}"
            echo "  • 每个功能一个分支"
            echo "  • 小步提交，频繁 commit"
            echo "  • 提交前运行测试"
            echo ""
            ;;

        "testing")
            echo -e "${YELLOW}🧪 阶段：测试中${NC}"
            echo ""
            echo "代码已写完，现在需要测试。"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 运行测试：npm test"
            echo "  2. 运行 E2E 测试：npm run test:e2e"
            echo "  3. 完成前验证：/verification-before-completion"
            echo ""
            echo -e "${CYAN}💡 提示:${NC} 代码已检测完成，建议立即运行验证流程。"
            echo ""
            # 自动更新状态为 verify
            update_project_state "verify" "代码完成，进入验证阶段"
            ;;

        "verify")
            echo -e "${YELLOW}🔍 阶段：验证和上传${NC}"
            echo ""
            echo "开发完成，现在需要验证和上传。"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 运行验证：/verification-before-completion"
            echo ""
            echo "验证完成后会自动："
            echo "  • 运行所有测试"
            echo "  • 检查代码质量"
            echo "  • 提交并推送到 GitHub"
            echo "  • 更新 README.md 和 CLAUDE.md"
            echo ""
            echo -e "${CYAN}💡 提示:${NC} 代码已检测完成，建议立即运行验证流程。"
            echo ""
            ;;

        "ready")
            echo -e "${GREEN}🎉 阶段：准备就绪${NC}"
            echo ""
            echo "项目看起来很不错！"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 运行：/compound-engineering:ce:review"
            echo "  2. 更新变更日志：/changelog"
            echo "  3. 创建 PR：/finishing-a-development-branch"
            echo ""
            ;;

        "completed")
            echo -e "${GREEN}🎊 阶段：已完成${NC}"
            echo ""
            echo "项目已成功完成并推送到远程仓库！"
            echo ""
            # 自动更新 README
            if [ -f "$SCRIPT_DIR/update_readme.sh" ]; then
                echo -e "${BLUE}更新项目文档...${NC}"
                bash "$SCRIPT_DIR/update_readme.sh"
            fi
            echo ""
            # 记录完成历史
            local timestamp=$(date "+%Y-%m-%d %H:%M:%S")
            echo "[$timestamp] completed - 项目完成并推送到 GitHub" >> "$GUIDE_HISTORY_FILE"
            echo -e "${GREEN}✓ 历史记录已更新${NC}"
            echo ""
            echo -e "${GREEN}推荐操作:${NC}"
            echo "  1. 开始新功能：/brainstorming"
            echo "  2. 查看项目：$GITHUB_URL"
            echo ""
            echo -e "${BLUE}💡 提示:${NC}"
            echo "  项目已完成基础功能，可以开始开发新功能！"
            echo ""
            ;;
    esac
}

# 显示最佳实践提示
show_best_practices() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  开发最佳实践${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}📌 代码提交${NC}"
    echo "  • 提交信息要清晰，说明做了什么和为什么"
    echo "  • 一个小功能一个提交"
    echo "  • 不要提交敏感信息（API 密钥、密码）"
    echo ""

    echo -e "${CYAN}📌 分支管理${NC}"
    echo "  • 使用 feature 分支开发新功能"
    echo "  • 定期从主分支合并更新"
    echo "  • 功能完成后及时删除分支"
    echo ""

    echo -e "${CYAN}📌 测试${NC}"
    echo "  • 新功能一定要写测试"
    echo "  • 保持测试覆盖率 > 80%"
    echo "  • 修复 bug 时先写一个复现测试"
    echo ""

    echo -e "${CYAN}📌 代码审查${NC}"
    echo "  • 提交 PR 前先自我审查"
    echo "  • 小 PR 更容易审查"
    echo "  • 认真对待审查意见"
    echo ""

    echo -e "${CYAN}📌 文档${NC}"
    echo "  • 及时更新 README"
    echo "  • 记录架构决策（ADRs）"
    echo "  • 更新变更日志"
    echo ""
}

# 显示技能速查
show_skills_cheat_sheet() {
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo -e "${BLUE}  技能速查表${NC}"
    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""

    echo -e "${CYAN}🚀 开始开发${NC}"
    echo "  /brainstorming          - 探索需求，设计方案"
    echo "  /writing-plans          - 创建实施计划"
    echo "  /using-git-worktrees    - 创建功能分支"
    echo ""

    echo -e "${CYAN}🔨 开发中${NC}"
    echo "  /test-driven-development - TDD 开发"
    echo "  /subagent-driven-development - 并行开发"
    echo ""

    echo -e "${CYAN}🐛 调试${NC}"
    echo "  /systematic-debugging   - 系统化调试"
    echo "  /compound-engineering:workflow:bug-reproduction-validator - 验证 bug"
    echo ""

    echo -e "${CYAN}✅ 完成${NC}"
    echo "  /requesting-code-review - 代码审查"
    echo "  /verification-before-completion - 完成前验证"
    echo "  /finishing-a-development-branch - 创建 PR"
    echo ""

    echo -e "${CYAN}🔍 审查${NC}"
    echo "  /compound-engineering:review:kieran-typescript-reviewer - TypeScript"
    echo "  /compound-engineering:review:kieran-rails-reviewer - Rails"
    echo "  /compound-engineering:review:security-sentinel - 安全审计"
    echo ""
}

# 交互式引导
interactive_guide() {
    show_welcome
    show_status
    show_stage_recommendation

    echo -e "${BLUE}════════════════════════════════════════════════════════${NC}"
    echo ""
    echo -e "${YELLOW}你想做什么？${NC}"
    echo ""
    echo "  1) 查看下一步建议"
    echo "  2) 查看最佳实践"
    echo "  3) 查看技能速查表"
    echo "  4) 运行完整检查"
    echo "  5) 开始 brainstorming"
    echo "  6) 提交并推送代码"
    echo "  7) 退出"
    echo ""

    read -p "请选择 (1-6): " -n 1 -r
    echo ""

    case $REPLY in
        1)
            show_stage_recommendation
            ;;
        2)
            show_best_practices
            ;;
        3)
            show_skills_cheat_sheet
            ;;
        4)
            echo ""
            bash scripts/check_setup.sh
            ;;
        5)
            echo ""
            echo -e "${GREEN}启动 brainstorming...${NC}"
            echo "运行：/brainstorming"
            ;;
        6)
            echo ""
            echo -e "${GREEN}提交并推送代码...${NC}"
            bash "$SCRIPT_DIR/git_commit.sh"
            ;;
        7)
            echo ""
            echo -e "${GREEN}再见！祝你开发顺利！🚀${NC}"
            echo ""
            exit 0
            ;;
    esac

    echo ""
    read -p "还要继续吗？(y/n) " -n 1 -r
    echo ""

    if [[ $REPLY =~ ^[Yy]$ ]]; then
        interactive_guide
    fi
}

# 自动引导（非交互）
auto_guide() {
    show_welcome
    show_status
    show_stage_recommendation
    show_best_practices
    show_skills_cheat_sheet
}

# 主函数
main() {
    case "${1:-interactive}" in
        "auto")
            auto_guide
            ;;
        "status")
            show_status
            ;;
        "recommendation")
            show_stage_recommendation
            ;;
        "best-practices")
            show_best_practices
            ;;
        "skills")
            show_skills_cheat_sheet
            ;;
        *)
            interactive_guide
            ;;
    esac
}

# 计算待办任务数
todo_count() {
    if [ -f ".todos" ]; then
        grep -c "pending" .todos 2>/dev/null || echo "0"
    else
        echo "0"
    fi
}

# 运行主函数
main "$@"