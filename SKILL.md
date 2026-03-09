# Harness Skill - 自动化项目引导系统

Harness engineer 风格的 Claude 项目自动化技能，提供智能引导系统，带领用户完成整个开发流程。

## 核心功能

- **智能引导系统** - 根据项目阶段自动给出下一步建议
- **自然语言驱动** - 完全不用记命令，用自然语言即可
- **状态追踪** - 自动记录项目进度（`.guide_state` + `.guide_history`）
- **交互式环境设置** - 初始化时逐步引导用户设置必要信息
- **自动化 Hooks** - 提交前检查、提交后更新文档
- **最佳实践集成** - 内建开发最佳实践

## 自然语言触发（完全不用记命令！）

| 用户说 | Claude 自动执行 |
|--------|----------------|
| "我迷路了" / "不知道做什么" | 显示完整引导菜单 |
| "下一步做什么" / "有什么建议" | 显示下一步建议 |
| "查看状态" / "当前进度" | 显示项目状态 |
| "查看最佳实践" | 显示最佳实践 |
| "技能列表" / "有什么技能" | 显示技能速查表 |
| "检查设置" / "检查配置" | 运行设置检查 |
| "初始化项目" | 在**当前项目目录**运行初始化 |
| "提交代码" / "推送代码" | 运行 git 提交并推送到 GitHub |

## 使用示例

### 示例 1: 用户迷路了

```
用户：我迷路了，不知道现在该做什么

Claude: （自动显示引导）
        👋 欢迎使用 Claude Project Guide
        当前阶段：development
        下一步建议：创建功能分支...
```

### 示例 2: 用户问下一步

```
用户：下一步做什么？

Claude: （自动显示建议）
        💻 阶段：开发中
        推荐操作：
          1. 创建功能分支：/using-git-worktrees
          2. 开始开发功能
```

## 核心技能命令

| 命令 | 用途 |
|------|------|
| `/brainstorming` | 需求探索 |
| `/writing-plans` | 创建计划 |
| `/test-driven-development` | TDD 开发 |
| `/systematic-debugging` | 调试 |
| `/using-git-worktrees` | 分支管理 |
| `/requesting-code-review` | 代码审查 |
| `/verification-before-completion` | 完成验证 |
| `/harness_skill 提交代码` | Git 提交并推送到 GitHub |

## 项目结构

```
harness_skill/
├── SKILL.md           # 本文件
├── skill.json         # 技能配置
├── README.md          # 项目说明
├── CLAUDE.md          # Claude 工作指引
├── scripts/           # 工具脚本
│   ├── guide.sh       # 智能引导
│   ├── check_setup.sh # 设置检查
│   ├── init_project.sh# 项目初始化
│   └── ...
└── docs/              # 文档
    ├── README.md              # 文档导航（推荐从这里开始）
    ├── 快速开始.md
    ├── 完整指南.md
    ├── API参考.md
    └── development_workflow.md
```

## 工作流程

```
项目初期 ──→ 项目开始 ──→ 开发中 ──→ 测试验证 ──→ 里程碑完成
```

1. **项目初期** - 在**项目目录**运行 `init_project.sh` 初始化
2. **项目开始** - `/brainstorming` → 创建设计文档 → 创建 todo（含测试任务）
3. **开发中** - 实现功能 → 完成所有实现任务
4. **测试验证** - 执行测试任务 → 验证功能 → 修复问题
5. **里程碑完成** - `/verification-before-completion` → `/finishing-a-development-branch`

## 重要：在项目目录下运行

**初始化时请确保在当前项目目录**（如 `/home/aixz/data/hxf/bigmodel/ai_code/test`）

```bash
# 1. 进入项目目录
cd /home/aixz/data/hxf/bigmodel/ai_code/test

# 2. 然后运行初始化
/harness_skill 初始化和引导
```

## Git 提交和推送

使用 `/harness_skill 提交代码` 命令会自动执行以下操作：

```bash
# 1. 暂存所有文件
git add .

# 2. 创建提交
git commit -m "你的提交信息"

# 3. 设置主分支
git branch -M main

# 4. 从 config/project.json 读取仓库地址并添加远程
git remote add origin https://github.com/hufeide/test3.git

# 5. 推送到 GitHub
git push -u origin main
```

**注意**: GitHub 仓库地址来自 `config/project.json` 中的 `github.url` 字段。

## 代理配置

如果需要代理访问 GitHub，在项目根目录创建 `.git_proxy` 文件：

```
host=192.168.1.159
port=10808
```

脚本会自动读取并配置代理：
```bash
export http_proxy="socks5://192.168.1.159:10808"
export https_proxy="socks5://192.168.1.159:10808"
```

## 故障排除

**迷路了？**
```
只需用自然语言说"我迷路了"或"下一步做什么"
```

**检查设置：**
```
只需用自然语言说"检查设置"
```

---

**作者：** fei
**版本：** 2.0.0