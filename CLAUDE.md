# CLAUDE.md

> Claude AI 工作指引

## 项目概述

**Claude 技能库** - 智能开发引导系统，提供自动化工作流和最佳实践。

### 核心功能

- 🤖 智能引导系统
- 🔄 自动化工作流
- 📚 文档管理
- 🛠️ 工具集成

---

## 快速参考

### 用户说什么时自动响应

| 用户说 | 自动执行 |
|--------|---------|
| "我迷路了" / "不知道做什么" | 显示完整引导 |
| "下一步做什么" / "有什么建议" | 显示下一步建议 |
| "查看状态" / "当前进度" | 显示项目状态 |
| "查看最佳实践" | 显示最佳实践 |
| "技能列表" / "有什么技能" | 显示技能速查表 |
| "检查设置" / "检查配置" | 运行设置检查 |
| "初始化项目" | 运行项目初始化 |

### 核心技能命令

| 命令 | 用途 |
|------|------|
| `/brainstorming` | 需求探索 |
| `/writing-plans` | 创建计划 |
| `/test-driven-development` | TDD 开发 |
| `/systematic-debugging` | 调试 |
| `/using-git-worktrees` | 分支管理 |
| `/requesting-code-review` | 代码审查 |
| `/verification-before-completion` | 完成验证 |
| `/finishing-a-development-branch` | 创建 PR |

### 核心脚本

| 脚本 | 用途 |
|------|------|
| `scripts/quickstart.sh` | 快速开始 |
| `scripts/guide.sh` | 智能引导 |
| `scripts/check_setup.sh` | 设置检查 |
| `scripts/update_docs.sh` | 更新文档 |

---

## 工作流程

```
项目初期 → 项目开始 → 开发中 → 里程碑完成
   ↓          ↓         ↓          ↓
 初始化    需求分析   功能开发   代码审查
```

### 阶段 1：项目初期

```bash
bash scripts/quickstart.sh
bash scripts/check_setup.sh
```

### 阶段 2：项目开始

```
/brainstorming → /writing-plans → 创建任务
```

### 阶段 3：开发中

```
/test-driven-development → 编码 → /requesting-code-review → /verification-before-completion
```

### 阶段 4：里程碑完成

```bash
npm test
bash scripts/update_docs.sh
/changelog
/finishing-a-development-branch
```

---

## 目录结构

```
项目根目录/
├── config/              # 配置文件
│   ├── env.json         # 环境变量
│   └── project.json     # 项目配置
├── docs/                # 文档
│   ├── 快速开始.md
│   ├── 完整指南.md
│   ├── API参考.md
│   ├── 最佳实践.md
│   ├── 故障排除.md
│   ├── plans/           # 设计文档
│   └── decisions/       # ADR 记录
├── scripts/             # 自动化脚本
├── examples/            # 示例项目
├── templates/           # 项目模板
├── src/                 # 源代码
├── tests/               # 测试文件
├── .guide_state         # 项目状态
└── .guide_history       # 活动历史
```

---

## 配置文件

### config/env.json

```json
{
  "PROJECT_NAME": "项目名称",
  "PROJECT_DESCRIPTION": "项目描述",
  "GITHUB_USER": "GitHub用户名",
  "GITHUB_REPO": "仓库名",
  "GITHUB_TOKEN": "访问令牌",
  "DATABASE_URL": "数据库连接",
  "MODEL": "claude-sonnet-3.5",
  "DEFAULT_BRANCH": "main"
}
```

---

## 最佳实践

### 代码提交

```
<type>(<scope>): <subject>

<body>

<footer>
```

类型：`feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`

### 分支命名

```
feature/<description>
bugfix/<description>
hotfix/<description>
```

### 测试覆盖率

- 总体覆盖率：> 80%
- 核心业务逻辑：> 90%

---

## 故障排除

### 迷路了？

```bash
bash scripts/guide.sh
# 或在 Claude 中说"我迷路了"
```

### 检查设置

```bash
bash scripts/check_setup.sh
```

### 技能找不到

```
/find-skills
```

---

## 文档链接

- [快速开始](docs/快速开始.md) - 5分钟上手
- [完整指南](docs/完整指南.md) - 详细功能说明
- [API参考](docs/API参考.md) - 所有命令
- [最佳实践](docs/最佳实践.md) - 工作流技巧
- [故障排除](docs/故障排除.md) - 常见问题

---

**版本**：2.0.0
**最后更新**：2026-03-09
