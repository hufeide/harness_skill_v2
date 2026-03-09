# 项目状态（harness_skill 自身）

> 这份文档用于记录本 skill 仓库的维护状态，避免“文档/脚本/配置”漂移。

## 当前状态

- **版本**：见 `skill.json` 与 `CHANGELOG.md`
- **核心入口**：`scripts/guide.sh`、`scripts/init_project.sh`、`scripts/check_setup.sh`

## 已知约定

- **业务项目状态文件**：`.guide_state` / `.guide_history`（应由业务项目 `.gitignore` 忽略）
- **业务项目基础结构**：见 `config/project_structure.json`

## 待办（维护侧）

- 保持 `docs/` 中的链接不失效（示例、模板、脚本名称一致）
- 为脚本增加更统一的 `--help`/`--non-interactive` 支持（逐步改进）

