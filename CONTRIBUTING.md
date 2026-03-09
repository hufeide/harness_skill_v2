# 贡献指南

> 感谢你考虑为 Claude 技能库做出贡献！

## 目录

- [行为准则](#行为准则)
- [如何贡献](#如何贡献)
- [开发流程](#开发流程)
- [代码规范](#代码规范)
- [提交规范](#提交规范)
- [文档规范](#文档规范)

---

## 行为准则

### 我们的承诺

为了营造一个开放和友好的环境，我们承诺：

- 使用友好和包容的语言
- 尊重不同的观点和经验
- 优雅地接受建设性批评
- 关注对社区最有利的事情
- 对其他社区成员表示同理心

### 不可接受的行为

- 使用性化的语言或图像
- 侮辱性/贬损性评论，人身攻击或政治攻击
- 公开或私下骚扰
- 未经明确许可，发布他人的私人信息
- 其他在专业环境中可能被认为不适当的行为

---

## 如何贡献

### 报告 Bug

在提交 Bug 报告前：

1. 检查 [Issues](https://github.com/yourusername/harness_skill/issues) 是否已有相同问题
2. 确保使用最新版本
3. 尝试在 [故障排除文档](docs/故障排除.md) 中查找解决方案

提交 Bug 报告时，请包含：

- **标题**：简洁描述问题
- **环境**：操作系统、版本等
- **重现步骤**：详细的重现步骤
- **预期行为**：你期望发生什么
- **实际行为**：实际发生了什么
- **截图**：如果适用
- **日志**：相关的错误日志

**Bug 报告模板**：

```markdown
## 环境
- OS: [e.g. macOS 13.0]
- Shell: [e.g. bash 5.1]
- Claude Code: [e.g. 1.0.0]

## 重现步骤
1. 运行 `bash scripts/guide.sh`
2. 选择选项 1
3. 看到错误

## 预期行为
应该显示下一步建议

## 实际行为
显示错误信息：...

## 日志
```
错误日志内容
```

## 截图
[如果适用]
```

### 建议新功能

在提交功能建议前：

1. 检查是否已有类似建议
2. 确保功能符合项目目标
3. 考虑功能的实用性

提交功能建议时，请包含：

- **标题**：简洁描述功能
- **动机**：为什么需要这个功能
- **详细描述**：功能的详细说明
- **替代方案**：考虑过的其他方案
- **示例**：使用示例

**功能建议模板**：

```markdown
## 功能描述
简洁描述你想要的功能

## 动机
为什么需要这个功能？它解决什么问题？

## 详细描述
详细说明功能应该如何工作

## 使用示例
```bash
# 示例代码
```

## 替代方案
考虑过的其他实现方式

## 额外信息
其他相关信息
```

### 提交 Pull Request

1. Fork 项目
2. 创建功能分支 (`git checkout -b feature/amazing-feature`)
3. 提交更改 (`git commit -m 'feat: add amazing feature'`)
4. 推送到分支 (`git push origin feature/amazing-feature`)
5. 创建 Pull Request

---

## 开发流程

### 1. 设置开发环境

```bash
# 克隆仓库
git clone https://github.com/yourusername/harness_skill.git
cd harness_skill

# 快速开始
bash scripts/quickstart.sh

# 验证安装
bash scripts/check_setup.sh
```

### 2. 创建功能分支

```bash
# 从 main 分支创建新分支
git checkout -b feature/your-feature-name

# 或使用 Git worktree
git worktree add ../harness_skill-feature feature/your-feature-name
```

### 3. 开发功能

遵循 [TDD 流程](docs/最佳实践.md#测试策略)：

```bash
# 1. 编写测试
# 2. 运行测试（应该失败）
bash scripts/run_tests.sh

# 3. 实现功能
# 4. 运行测试（应该通过）
bash scripts/run_tests.sh

# 5. 重构
```

### 4. 提交更改

```bash
# 添加更改
git add .

# 提交（遵循提交规范）
git commit -m "feat(scope): add new feature"

# 推送
git push origin feature/your-feature-name
```

### 5. 创建 Pull Request

在 GitHub 上创建 PR，包含：

- **标题**：遵循提交规范
- **描述**：详细说明更改
- **关联 Issue**：如果适用
- **测试**：说明如何测试
- **截图**：如果适用

**PR 模板**：

```markdown
## 更改类型
- [ ] Bug 修复
- [ ] 新功能
- [ ] 文档更新
- [ ] 代码重构
- [ ] 性能优化

## 描述
详细描述你的更改

## 关联 Issue
Closes #123

## 测试
如何测试这些更改？

## 检查清单
- [ ] 代码遵循项目规范
- [ ] 已添加/更新测试
- [ ] 所有测试通过
- [ ] 已更新文档
- [ ] 已更新 CHANGELOG.md
```

---

## 代码规范

### Bash 脚本规范

```bash
#!/bin/bash
# 脚本描述

# 严格模式
set -e  # 遇到错误立即退出
set -u  # 使用未定义变量时报错

# 常量使用大写
readonly PROJECT_DIR="$(pwd)"
readonly CONFIG_FILE="config/env.json"

# 函数命名使用小写和下划线
function check_dependencies() {
    # 函数实现
}

# 错误处理
error_exit() {
    echo "❌ 错误: $1" >&2
    exit 1
}

# 使用示例
command || error_exit "命令执行失败"
```

### 文档规范

- 使用 Markdown 格式
- 标题使用 ATX 风格（`#`）
- 代码块指定语言
- 链接使用相对路径
- 中英文之间加空格

**示例**：

```markdown
# 一级标题

## 二级标题

这是一段文字，包含 English 和中文。

### 代码示例

```bash
echo "Hello World"
```

### 链接

查看 [快速开始](docs/快速开始.md) 了解更多。
```

---

## 提交规范

使用 [Conventional Commits](https://www.conventionalcommits.org/) 规范：

```
<type>(<scope>): <subject>

<body>

<footer>
```

### Type 类型

| Type | 说明 | 示例 |
|------|------|------|
| `feat` | 新功能 | `feat(guide): 添加交互式教程` |
| `fix` | Bug 修复 | `fix(script): 修复路径错误` |
| `docs` | 文档更新 | `docs(readme): 更新安装说明` |
| `style` | 代码格式 | `style(bash): 统一缩进格式` |
| `refactor` | 重构 | `refactor(guide): 重构引导逻辑` |
| `test` | 测试 | `test(script): 添加单元测试` |
| `chore` | 构建/工具 | `chore(deps): 更新依赖` |
| `perf` | 性能优化 | `perf(script): 优化脚本性能` |

### Scope 范围

- `guide` - 引导系统
- `script` - 脚本
- `docs` - 文档
- `config` - 配置
- `example` - 示例
- `template` - 模板

### Subject 主题

- 使用祈使句，现在时
- 不要大写首字母
- 不要以句号结尾
- 限制在 50 字符内

### Body 正文

- 详细说明更改的动机
- 与之前行为的对比
- 每行限制在 72 字符内

### Footer 页脚

- 关联 Issue：`Closes #123`
- 破坏性变更：`BREAKING CHANGE: ...`

### 完整示例

```
feat(guide): 添加交互式教程功能

添加了一个新的交互式教程，帮助新用户快速上手。
教程包括：
- 项目初始化
- 基本配置
- 第一个功能开发

教程使用问答式交互，更加友好。

Closes #45
```

---

## 文档规范

### 文档结构

```markdown
# 标题

> 简短描述

## 目录

- [章节1](#章节1)
- [章节2](#章节2)

---

## 章节1

内容...

## 章节2

内容...

---

**文档版本**：1.0
**最后更新**：2026-03-09
```

### 代码示例

````markdown
### 示例标题

```bash
# 注释说明
command --option value
```

**输出**：
```
预期输出内容
```
````

### 链接规范

```markdown
# 内部链接（相对路径）
查看 [快速开始](docs/快速开始.md)

# 外部链接
访问 [GitHub](https://github.com)

# 锚点链接
跳转到 [章节2](#章节2)
```

---

## 审查流程

### PR 审查标准

- [ ] 代码符合规范
- [ ] 测试覆盖充分
- [ ] 文档已更新
- [ ] 提交信息规范
- [ ] 无冲突
- [ ] CI 通过

### 审查反馈

**给出反馈时**：
- 具体指出问题
- 提供改进建议
- 解释原因
- 保持友好

**接收反馈时**：
- 保持开放心态
- 理解审查意图
- 讨论不同观点
- 及时响应

---

## 发布流程

### 版本号

遵循 [语义化版本](https://semver.org/lang/zh-CN/)：

- **主版本号**：不兼容的 API 修改
- **次版本号**：向下兼容的功能性新增
- **修订号**：向下兼容的问题修正

### 发布步骤

1. 更新 CHANGELOG.md
2. 更新版本号
3. 创建标签
4. 推送标签
5. 创建 GitHub Release

```bash
# 更新版本号
vim skill.json  # 修改 version

# 提交更改
git add .
git commit -m "chore: bump version to 2.1.0"

# 创建标签
git tag -a v2.1.0 -m "Release v2.1.0"

# 推送
git push origin main
git push origin v2.1.0

# 创建 GitHub Release
gh release create v2.1.0 --notes "Release notes..."
```

---

## 获取帮助

- 📖 查看 [文档](docs/)
- 💬 提交 [Issue](https://github.com/yourusername/harness_skill/issues)
- 💡 参与 [讨论](https://github.com/yourusername/harness_skill/discussions)

---

**感谢你的贡献！** 🎉

每一个贡献，无论大小，都让这个项目变得更好。
