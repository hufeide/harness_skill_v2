# API 参考手册

> 所有命令、脚本和技能的完整参考

## 目录

- [脚本命令](#脚本命令)
- [技能命令](#技能命令)
- [Compound Engineering 技能](#compound-engineering-技能)
- [自然语言触发](#自然语言触发)
- [配置文件](#配置文件)

---

## 脚本命令

### 核心脚本

#### quickstart.sh

一键快速开始脚本。

```bash
bash scripts/quickstart.sh
```

**功能**：
- 检查环境依赖
- 创建配置文件
- 初始化项目结构
- 运行验证检查
- 显示下一步建议

**使用场景**：首次使用项目时

---

#### init_project.sh

项目初始化脚本。

```bash
bash scripts/init_project.sh
```

**功能**：
- 创建项目目录结构
- 生成配置文件
- 初始化Git仓库
- 创建基础文档

**创建的文件**：
```
config/env.json
docs/plans/
docs/decisions/
src/
tests/
CLAUDE.md
README.md
.gitignore
.guide_state
```

---

#### guide.sh

智能引导脚本。

```bash
# 交互式模式
bash scripts/guide.sh

# 自动模式（显示建议）
bash scripts/guide.sh auto

# 显示状态
bash scripts/guide.sh status

# 显示最佳实践
bash scripts/guide.sh best-practices

# 显示技能列表
bash scripts/guide.sh skills
```

**功能**：
- 显示当前项目阶段
- 提供下一步建议
- 展示最佳实践
- 列出可用技能

**使用场景**：不知道下一步做什么时

---

#### check_setup.sh

设置验证脚本。

```bash
bash scripts/check_setup.sh
```

**检查项目**（16项）：
1. Claude Code CLI 安装
2. Git 安装
3. 配置文件存在
4. 环境变量设置
5. 技能安装
6. Hooks 配置
7. 插件安装
8. 目录结构
9. Git 仓库初始化
10. 文档文件存在
11. 脚本可执行权限
12. 状态文件
13. MCP 服务器配置
14. 测试框架
15. 代码质量工具
16. 文档完整性

**输出示例**：
```
✅ Claude Code CLI 已安装
✅ Git 已安装
...
✅ 所有检查通过！(16/16)
```

---

#### update_docs.sh

文档更新脚本。

```bash
bash scripts/update_docs.sh
```

**功能**：
- 更新 README.md
- 更新 CLAUDE.md
- 生成 API 文档
- 更新变更日志

**使用场景**：完成里程碑后

---

#### update_state.sh

状态管理脚本。

```bash
# 显示当前状态
bash scripts/update_state.sh show

# 更新状态
bash scripts/update_state.sh update <stage> <activity>

# 查看历史
bash scripts/update_state.sh history
```

**参数**：
- `<stage>`: initiation | kickoff | development | milestone
- `<activity>`: 活动描述

**示例**：
```bash
bash scripts/update_state.sh update development "实现用户认证功能"
```

---

#### create_issues.sh

GitHub Issues 创建脚本。

```bash
bash scripts/create_issues.sh
```

**功能**：
- 从任务列表创建 GitHub issues
- 自动添加标签
- 设置里程碑

**前置条件**：
- 配置 GITHUB_TOKEN
- 设置 GITHUB_USER 和 GITHUB_REPO

---

#### setup_hooks.sh

Hooks 配置脚本。

```bash
bash scripts/setup_hooks.sh
```

**功能**：
- 创建 pre_commit hook
- 创建 post_commit hook
- 设置可执行权限

**Hooks 说明**：
- `pre_commit`: 提交前运行代码检查和测试
- `post_commit`: 提交后更新文档

---

#### setup_plugins.sh

插件安装脚本。

```bash
bash scripts/setup_plugins.sh
```

**功能**：
- 安装 Claude 技能
- 安装 MCP 服务器
- 配置 Compound Engineering

---

### 辅助脚本

#### set_remote.sh

设置 Git 远程仓库。

```bash
bash scripts/set_remote.sh <github-url>
```

**示例**：
```bash
bash scripts/set_remote.sh https://github.com/username/repo.git
```

---

#### verify_and_upload.sh

验证并上传到 GitHub。

```bash
bash scripts/verify_and_upload.sh
```

**功能**：
- 运行所有检查
- 提交代码
- 推送到远程仓库

---

## 技能命令

### 核心技能

#### /brainstorming

需求探索和方案设计。

**使用场景**：
- 开始新功能开发
- 探索技术方案
- 架构设计

**流程**：
1. 探索项目上下文
2. 回答澄清问题
3. 提出2-3种方案
4. 创建设计文档

**输出**：
- `docs/plans/YYYY-MM-DD-<topic>-design.md`

---

#### /writing-plans

创建详细实施计划。

**使用场景**：
- 需求明确后
- 开始开发前

**输出**：
- 任务清单
- 依赖关系
- 关键文件列表
- 时间估算

---

#### /test-driven-development

测试驱动开发。

**使用场景**：
- 开发新功能
- 重构代码

**流程**：
1. 编写失败的测试
2. 实现最少代码让测试通过
3. 重构代码
4. 重复

---

#### /systematic-debugging

系统化调试。

**使用场景**：
- 遇到 bug
- 性能问题
- 异常行为

**流程**：
1. 理解问题
2. 复现 bug
3. 定位原因
4. 提出修复方案
5. 实施修复
6. 验证修复

---

#### /using-git-worktrees

Git 工作树管理。

**使用场景**：
- 开始新功能分支
- 并行开发多个功能
- 快速切换上下文

**功能**：
- 创建独立工作目录
- 共享 Git 历史
- 支持多窗口开发

---

#### /requesting-code-review

代码审查请求。

**使用场景**：
- 功能开发完成
- 准备提交 PR

**审查内容**：
- 代码质量
- 可读性
- 性能
- 安全性
- 最佳实践

---

#### /verification-before-completion

完成前验证。

**使用场景**：
- 提交代码前
- 创建 PR 前

**检查清单**：
- [ ] 所有测试通过
- [ ] 代码审查完成
- [ ] 文档已更新
- [ ] 变更日志已更新
- [ ] 无遗留 TODO
- [ ] 符合编码规范

---

#### /finishing-a-development-branch

完成开发分支。

**使用场景**：
- 功能开发完成
- 准备合并到主分支

**功能**：
- 创建 PR
- 生成 PR 描述
- 添加标签
- 请求审查

---

#### /subagent-driven-development

子代理驱动开发。

**使用场景**：
- 复杂功能开发
- 并行任务执行

**功能**：
- 分解任务
- 并行执行
- 结果整合

---

## Compound Engineering 技能

### 计划和执行

#### /compound-engineering:ce:plan

创建详细计划。

```
/compound-engineering:ce:plan
```

---

#### /compound-engineering:ce:work

执行工作任务。

```
/compound-engineering:ce:work
```

---

#### /compound-engineering:ce:review

代码审查。

```
/compound-engineering:ce:review
```

---

### 专业审查

#### 语言特定审查

```
# Rails (DHH 风格)
/compound-engineering:review:dhh-rails-reviewer

# Rails (高质量)
/compound-engineering:review:kieran-rails-reviewer

# TypeScript
/compound-engineering:review:kieran-typescript-reviewer

# Python
/compound-engineering:review:kieran-python-reviewer
```

#### 专项审查

```
# 代码简化
/compound-engineering:review:code-simplicity-reviewer

# 安全审计
/compound-engineering:review:security-sentinel

# 性能分析
/compound-engineering:review:performance-oracle

# 部署验证
/compound-engineering:review:deployment-verification-agent
```

---

### 工作流

```
# TODO 并行处理
/compound-engineering:resolve_todo_parallel

# 浏览器测试
/compound-engineering:test-browser

# PR 评论处理
/compound-engineering:workflow:pr-comment-resolver

# Bug 复现验证
/compound-engineering:workflow:bug-reproduction-validator
```

---

## 自然语言触发

在 Claude 中使用自然语言，无需记住命令。

### 引导相关

| 说法 | 触发功能 |
|------|---------|
| "我迷路了" | 显示完整引导菜单 |
| "不知道做什么" | 显示下一步建议 |
| "查看引导" | 显示完整引导菜单 |
| "有什么建议" | 显示下一步建议 |
| "下一步做什么" | 显示下一步建议 |

### 状态相关

| 说法 | 触发功能 |
|------|---------|
| "查看状态" | 显示项目状态 |
| "当前进度" | 显示项目状态 |
| "项目状态" | 显示项目状态 |

### 功能相关

| 说法 | 触发功能 |
|------|---------|
| "查看最佳实践" | 显示最佳实践 |
| "技能列表" | 显示技能速查表 |
| "有什么技能" | 显示技能速查表 |
| "检查设置" | 运行设置检查 |
| "检查配置" | 运行设置检查 |
| "初始化项目" | 运行项目初始化 |

---

## 配置文件

### config/env.json

环境变量配置。

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

**字段说明**：

- `PROJECT_NAME` (必填): 项目名称
- `PROJECT_DESCRIPTION` (可选): 项目描述
- `GITHUB_USER` (可选): GitHub 用户名，创建 issues 时需要
- `GITHUB_REPO` (可选): 仓库名，创建 issues 时需要
- `GITHUB_TOKEN` (可选): GitHub 访问令牌，创建 issues 时需要
- `DATABASE_URL` (可选): 数据库连接字符串
- `MODEL` (可选): Claude 模型版本
- `DEFAULT_BRANCH` (可选): 默认分支名

---

### config/project.json

项目配置。

```json
{
  "github": {
    "user": "用户名",
    "repo": "仓库名",
    "url": "仓库URL",
    "token": "访问令牌"
  },
  "project": {
    "name": "项目名",
    "description": "描述",
    "default_branch": "main"
  }
}
```

---

### skill.json

技能库配置。

```json
{
  "name": "harness_skill",
  "version": "2.0.0",
  "plugins": {
    "skills": ["brainstorming", "writing-plans", ...],
    "mcp": ["mongodb-mcp-server", ...],
    "compound-engineering": "..."
  },
  "hooks": {
    "pre_commit": "~/.claude/hooks/pre_commit",
    "post_commit": "~/.claude/hooks/post_commit"
  }
}
```

---

## 状态文件

### .guide_state

当前项目状态。

```
stage=development
last_activity=实现用户认证功能
timestamp=2026-03-09 10:30:00
```

### .guide_history

活动历史记录。

```
2026-03-09 09:00:00 | initiation | 项目初始化
2026-03-09 09:30:00 | kickoff | 需求分析完成
2026-03-09 10:30:00 | development | 实现用户认证功能
```

---

## 返回码

所有脚本使用标准返回码：

- `0` - 成功
- `1` - 一般错误
- `2` - 配置错误
- `3` - 依赖缺失
- `4` - 权限错误

---

**文档版本**：1.0
**最后更新**：2026-03-09
