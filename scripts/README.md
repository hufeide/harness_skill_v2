# 脚本说明

> 所有自动化脚本的使用说明和依赖关系

## 脚本列表

### 核心脚本

| 脚本 | 用途 | 使用频率 |
|------|------|---------|
| `quickstart.sh` | 一键快速开始 | 首次使用 |
| `init_project.sh` | 项目初始化 | 首次使用 |
| `guide.sh` | 智能引导 | 经常使用 |
| `check_setup.sh` | 设置验证 | 经常使用 |

### 辅助脚本

| 脚本 | 用途 | 使用频率 |
|------|------|---------|
| `update_docs.sh` | 更新文档 | 里程碑完成时 |
| `update_state.sh` | 状态管理 | 自动调用 |
| `create_issues.sh` | 创建 issues | 按需使用 |
| `setup_hooks.sh` | 配置 Hooks | 首次使用 |
| `setup_plugins.sh` | 安装插件 | 首次使用 |
| `set_remote.sh` | 设置远程仓库 | 按需使用 |
| `verify_and_upload.sh` | 验证并上传 | 按需使用 |

---

## 执行顺序

### 首次使用

#### 方式 A：快速开始（推荐）

```bash
quickstart.sh
```

这会自动执行：
1. `check_setup.sh` - 检查环境
2. `init_project.sh` - 初始化项目
3. `setup_plugins.sh` - 安装插件
4. `setup_hooks.sh` - 配置 Hooks
5. `check_setup.sh` - 验证安装

#### 方式 B：手动执行

```bash
# 1. 初始化项目
bash scripts/init_project.sh

# 2. 安装插件
bash scripts/setup_plugins.sh

# 3. 配置 Hooks
bash scripts/setup_hooks.sh

# 4. 验证安装
bash scripts/check_setup.sh
```

### 日常使用

```bash
# 查看引导
bash scripts/guide.sh

# 检查状态
bash scripts/update_state.sh show

# 更新文档
bash scripts/update_docs.sh
```

---

## 脚本依赖关系

```
quickstart.sh
  ├── check_setup.sh (前置检查)
  ├── init_project.sh
  │   ├── 创建目录结构
  │   ├── 生成配置文件
  │   └── 初始化 Git
  ├── setup_plugins.sh
  │   ├── 安装 Claude 技能
  │   ├── 安装 MCP 服务器
  │   └── 配置 Compound Engineering
  ├── setup_hooks.sh
  │   ├── 创建 pre_commit
  │   └── 创建 post_commit
  └── check_setup.sh (验证)

guide.sh
  ├── 读取 .guide_state
  ├── 分析项目阶段
  └── 提供建议

update_docs.sh
  ├── 更新 README.md
  ├── 更新 CLAUDE.md
  └── 生成 API 文档

create_issues.sh
  ├── 读取任务列表
  ├── 调用 GitHub API
  └── 创建 issues
```

---

## 详细说明

### quickstart.sh

**用途**：一键快速开始

**功能**：
- 检查环境依赖
- 创建配置文件
- 初始化项目结构
- 安装插件和 Hooks
- 运行验证检查
- 显示下一步建议

**使用**：
```bash
bash scripts/quickstart.sh
```

**输出**：
```
🚀 Claude 技能库快速开始

检查环境...
✅ Git 已安装
✅ Bash 已安装

初始化项目...
✅ 目录结构已创建
✅ 配置文件已生成

安装插件...
✅ 技能已安装
✅ MCP 服务器已配置

配置 Hooks...
✅ pre_commit 已创建
✅ post_commit 已创建

验证安装...
✅ 所有检查通过！(16/16)

🎉 快速开始完成！

下一步建议：
1. 编辑 config/env.json 配置环境变量
2. 在 Claude 中说"我迷路了"开始引导
3. 运行 bash scripts/guide.sh 查看详细引导
```

---

### init_project.sh

**用途**：项目初始化

**功能**：
- 创建项目目录结构
- 生成配置文件
- 初始化 Git 仓库
- 创建基础文档

**使用**：
```bash
bash scripts/init_project.sh
```

**创建的结构**：
```
<当前目录>/
├── config/
│   ├── env.json
│   ├── project.json
│   └── permissions.json
├── docs/
│   ├── plans/
│   └── decisions/
├── src/
├── tests/
├── CLAUDE.md
├── README.md
├── .gitignore
└── .guide_state
```

**环境变量**：
- `PROJECT_DIR` - 项目目录（默认：当前目录）

---

### guide.sh

**用途**：智能引导系统

**功能**：
- 显示当前项目状态
- 提供下一步建议
- 展示最佳实践
- 列出可用技能

**使用**：
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

**交互式菜单**：
```
👋 欢迎使用 Claude Project Guide

当前阶段：development
最后活动：实现用户认证功能

你想做什么？

  1) 查看下一步建议
  2) 查看最佳实践
  3) 查看技能速查表
  4) 运行完整检查
  5) 开始 brainstorming
  6) 退出

请选择 (1-6):
```

---

### check_setup.sh

**用途**：设置验证

**功能**：
- 检查环境依赖
- 验证配置文件
- 检查技能安装
- 验证 Hooks 配置

**使用**：
```bash
bash scripts/check_setup.sh
```

**检查项目**（16项）：
1. ✅ Claude Code CLI 安装
2. ✅ Git 安装
3. ✅ 配置文件存在
4. ✅ 环境变量设置
5. ✅ 技能安装
6. ✅ Hooks 配置
7. ✅ 插件安装
8. ✅ 目录结构
9. ✅ Git 仓库初始化
10. ✅ 文档文件存在
11. ✅ 脚本可执行权限
12. ✅ 状态文件
13. ✅ MCP 服务器配置
14. ✅ 测试框架
15. ✅ 代码质量工具
16. ✅ 文档完整性

**返回码**：
- `0` - 所有检查通过
- `1` - 有检查失败

---

### update_docs.sh

**用途**：文档更新

**功能**：
- 更新 README.md
- 更新 CLAUDE.md
- 生成 API 文档
- 更新变更日志

**使用**：
```bash
bash scripts/update_docs.sh
```

**使用时机**：
- 完成里程碑后
- 添加新功能后
- 修改 API 后

---

### update_state.sh

**用途**：状态管理

**功能**：
- 显示当前状态
- 更新项目状态
- 查看活动历史

**使用**：
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

**状态文件**：
- `.guide_state` - 当前状态
- `.guide_history` - 活动历史

---

### create_issues.sh

**用途**：创建 GitHub Issues

**功能**：
- 从任务列表创建 issues
- 自动添加标签
- 设置里程碑

**使用**：
```bash
bash scripts/create_issues.sh
```

**前置条件**：
- 配置 `GITHUB_TOKEN`
- 设置 `GITHUB_USER` 和 `GITHUB_REPO`

**环境变量**：
```bash
export GITHUB_TOKEN="ghp_..."
export GITHUB_USER="username"
export GITHUB_REPO="repo-name"
```

---

### setup_hooks.sh

**用途**：配置 Git Hooks

**功能**：
- 创建 pre_commit hook
- 创建 post_commit hook
- 设置可执行权限

**使用**：
```bash
bash scripts/setup_hooks.sh
```

**创建的 Hooks**：

**pre_commit**：
- 运行代码检查（lint）
- 运行测试
- 检查提交信息格式

**post_commit**：
- 更新文档
- 更新状态文件

**位置**：
- `~/.claude/hooks/pre_commit`
- `~/.claude/hooks/post_commit`

---

### setup_plugins.sh

**用途**：安装插件

**功能**：
- 安装 Claude 技能
- 安装 MCP 服务器
- 配置 Compound Engineering

**使用**：
```bash
bash scripts/setup_plugins.sh
```

**安装的插件**：

**技能**：
- brainstorming
- writing-plans
- test-driven-development
- systematic-debugging
- using-git-worktrees
- requesting-code-review
- verification-before-completion
- subagent-driven-development
- finishing-a-development-branch

**MCP 服务器**：
- mongodb-mcp-server
- playwright-mcp
- vercel-mcp

---

### set_remote.sh

**用途**：设置 Git 远程仓库

**功能**：
- 添加远程仓库
- 验证连接
- 推送代码

**使用**：
```bash
bash scripts/set_remote.sh <github-url>
```

**示例**：
```bash
bash scripts/set_remote.sh https://github.com/username/repo.git
```

---

### verify_and_upload.sh

**用途**：验证并上传

**功能**：
- 运行所有检查
- 提交代码
- 推送到远程仓库

**使用**：
```bash
bash scripts/verify_and_upload.sh
```

**流程**：
1. 运行 `check_setup.sh`
2. 运行测试
3. 提交代码
4. 推送到远程

---

## 环境变量

### 全局环境变量

```bash
# 项目目录
export PROJECT_DIR="$(pwd)"

# 跳过网络检查（加速）
export SKIP_NETWORK_CHECKS=1

# 调试模式
export DEBUG=1
```

### 配置文件环境变量

在 `config/env.json` 中配置：

```json
{
  "PROJECT_NAME": "项目名称",
  "GITHUB_TOKEN": "GitHub 令牌",
  "GITHUB_USER": "GitHub 用户名",
  "GITHUB_REPO": "仓库名",
  "DATABASE_URL": "数据库连接",
  "MODEL": "claude-sonnet-3.5",
  "DEFAULT_BRANCH": "main"
}
```

---

## 调试脚本

### 启用调试模式

```bash
# 显示执行的每一行命令
bash -x scripts/guide.sh

# 或设置环境变量
export DEBUG=1
bash scripts/guide.sh
```

### 查看日志

```bash
# 重定向输出到文件
bash scripts/check_setup.sh 2>&1 | tee setup.log

# 查看日志
cat setup.log
```

---

## 常见问题

### Q: 脚本没有执行权限

```bash
chmod +x scripts/*.sh
```

### Q: 脚本找不到命令

安装缺失的依赖：
```bash
# macOS
brew install jq

# Ubuntu/Debian
sudo apt-get install jq
```

### Q: 脚本执行卡住

按 `Ctrl+C` 终止，然后：
```bash
bash -x scripts/guide.sh
```

---

## 贡献

欢迎贡献新的脚本！请遵循：

1. 使用 Bash
2. 添加错误处理
3. 添加使用说明
4. 更新本文档

---

**文档版本**：1.0
**最后更新**：2026-03-09
