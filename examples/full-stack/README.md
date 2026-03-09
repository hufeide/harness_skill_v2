# full-stack（示例）

这个示例用于演示：把 `harness_skill` 用在一个包含前后端的项目里（同样以流程为主，不绑定具体技术栈）。

## 推荐结构

你可以用单仓库结构：

- `src/`：后端或共享逻辑
- `web/`：前端（可选）
- `tests/`：测试
- `docs/`：设计、ADR、故障排查等

## 建议步骤

1. 初始化项目：

```bash
mkdir full-stack && cd full-stack
bash ~/.claude/skills/harness_skill/scripts/init_project.sh
```

2. 在 Claude 中跑通一次完整迭代：

- `/brainstorming`：明确前后端边界、数据模型、接口契约
- `/writing-plans`：拆解为可并行的 TODO（前端/后端/测试）
- `/subagent-driven-development`：并行推进（可选）
- `/requesting-code-review`：合并前审查
- `/verification-before-completion`：提交前验证


