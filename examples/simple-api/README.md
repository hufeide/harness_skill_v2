# simple-api（示例）

这个示例用于演示：在一个“空项目目录”里，如何用 `harness_skill` 完成初始化、进入工作流，并产出最小可运行的 API（示例仅给结构与步骤，不强制绑定具体框架）。

## 目标

- 让你跑通一次完整流程：初始化 → 需求探索 → 计划 → 开发 → 测试 → 验证

## 建议步骤

1. 在新目录创建项目并初始化：

```bash
mkdir simple-api && cd simple-api
bash ~/.claude/skills/harness_skill/scripts/init_project.sh
```

2. 在 Claude 中执行：

- `/brainstorming`（明确 API 需求与路由）
- `/writing-plans`（生成实施计划与任务列表）
- `/test-driven-development`（以 TDD 方式推进）

3. 产出建议的最小文件集合：

- `src/`：你的 API 代码
- `tests/`：单元测试 / 集成测试
- `docs/plans/`：设计文档
- `docs/decisions/`：关键架构决策（ADR）

## 校验

```bash
bash scripts/check_setup.sh
bash scripts/guide.sh auto
```


