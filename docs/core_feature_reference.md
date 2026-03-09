# 核心功能参考（harness_skill）

## 1) 智能引导（Guide）

- **入口**：`scripts/guide.sh`
- **目的**：根据业务项目当前状态（初始化、规划、开发、测试、验证）给出下一步建议
- **状态来源**：
  - 自动检测（目录/文件存在性）
  - `.guide_state` / `.guide_history`（可读可写）

## 2) 状态管理（State）

- **入口**：`scripts/update_state.sh`
- **能力**：
  - `show`：显示当前状态与最近历史
  - `history`：展示完整历史
  - `update <stage> <activity>`：写入状态与追加历史

## 3) 项目初始化（Init）

- **入口**：`scripts/init_project.sh`
- **目的**：在业务项目目录创建/补齐基础结构与配置（并尽量避免在 skill 目录误用）
- **输出**：`config/`、`docs/`、`src/`、`tests/`、以及 `.guide_state/.guide_history`

## 4) 环境检查（Check）

- **入口**：`scripts/check_setup.sh`
- **目的**：检查 Claude CLI、插件、核心 skills、hooks、以及项目基础文件

## 5) Hooks（可选）

- **入口**：`scripts/setup_hooks.sh`
- **目的**：创建 `~/.claude/hooks/pre_commit` 与 `post_commit`，用于提交前检查与提交后更新文档

