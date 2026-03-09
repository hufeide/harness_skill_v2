# 架构说明（harness_skill）

> 这份文档解释：这个仓库里有哪些组件、它们如何协作、以及“skill 仓库”和“业务项目目录”的边界。

## 两个概念：skill 仓库 vs 业务项目

- **skill 仓库（本仓库）**：提供脚本、配置模板、文档、示例与模板。通常安装在 `~/.claude/skills/harness_skill/`。
- **业务项目目录（你的项目）**：你正在开发的仓库；脚本会在这个目录里创建 `config/`、`docs/`、`src/`、`tests/` 等结构，并维护 `.guide_state/.guide_history` 这类运行时状态文件。

## 组件划分

### scripts/

- **引导与状态**：`guide.sh`、`update_state.sh`
- **初始化**：`init_project.sh`（在业务项目目录运行）
- **环境/依赖检查**：`check_setup.sh`
- **插件/技能检查**：`setup_plugins.sh`
- **Hooks 管理**：`setup_hooks.sh`

### config/

- `env.example.json`：环境配置示例
- `project.json`：项目与 GitHub 信息（初始化脚本会为业务项目生成）
- `permissions.json`：权限模板（初始化脚本会复制到业务项目的 `.claude/settings.local.json`）
- `project_structure.json`：项目结构约定（文档与脚本对齐用）

### docs/

分层文档：快速开始、完整指南、API 参考、最佳实践、故障排除，以及 `plans/` 与 `decisions/`。

## 关键设计原则

- **可重复执行**：脚本尽量 idempotent（重复运行不会破坏状态）
- **默认安全**：避免 destructive 默认行为（例如自动删除/覆盖）
- **约定优于配置**：用 `src/`、`tests/`、`docs/` 约定减少沟通成本

