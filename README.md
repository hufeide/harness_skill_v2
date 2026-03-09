# Claude 技能库 - 智能开发引导系统

> 让 Claude 成为你的开发伙伴，提供智能引导和自动化工作流

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Version](https://img.shields.io/badge/version-2.0.0-blue.svg)](https://github.com/yourusername/harness_skill)

## 30秒了解

这个技能库能做什么？

- ✅ **智能引导**：不知道下一步做什么？说"我迷路了"，Claude会告诉你
- ✅ **自动化工作流**：提交代码自动检查、自动更新文档、自动创建issues
- ✅ **最佳实践内置**：TDD开发、代码审查、Git工作流一应俱全
- ✅ **自然语言驱动**：完全不用记命令，用自然语言就能操作

## 5分钟快速开始

```bash
# 1. 克隆项目
git clone https://github.com/yourusername/harness_skill.git
cd harness_skill

# 2. 一键快速开始
bash scripts/quickstart.sh

# 3. 在Claude中说"我迷路了"，开始你的开发之旅
```

就这么简单！🎉

## 核心功能

### 智能引导系统

```bash
# 查看当前状态和下一步建议
bash scripts/guide.sh

# 或者直接在Claude中说：
# "我迷路了"
# "下一步做什么"
# "查看状态"
```

### 完整开发工作流

```
项目初期 → 需求分析 → 任务规划 → 功能开发 → 代码审查 → 部署上线
   ↓          ↓         ↓         ↓         ↓         ↓
 初始化   brainstorming  创建计划   TDD开发   自动审查   验证完成
```

### 自动化工具

- **Hooks**：提交前自动检查代码质量和测试
- **文档管理**：自动更新文档和变更日志
- **GitHub集成**：自动创建和管理issues
- **多窗口开发**：Git worktrees支持并行开发

## 技能命令速查

| 场景 | 命令 | 说明 |
|------|------|------|
| 开始新功能 | `/brainstorming` | 需求探索和方案设计 |
| 创建计划 | `/writing-plans` | 生成详细实施计划 |
| 开发功能 | `/test-driven-development` | TDD方式开发 |
| 调试问题 | `/systematic-debugging` | 系统化调试流程 |
| 代码审查 | `/requesting-code-review` | 专业代码审查 |
| 完成验证 | `/verification-before-completion` | 提交前完整检查 |

## 文档导航

- 📖 [快速开始指南](docs/快速开始.md) - 5分钟上手
- 📚 [完整使用指南](docs/完整指南.md) - 详细功能说明
- 🔧 [API参考手册](docs/API参考.md) - 所有命令和脚本
- 💡 [最佳实践](docs/最佳实践.md) - 工作流和技巧
- 🔍 [故障排除](docs/故障排除.md) - 常见问题解决

## 示例项目

查看 `examples/` 目录了解实际使用案例：

- [simple-api](examples/simple-api/) - 简单REST API开发示例
- [full-stack](examples/full-stack/) - 全栈应用开发示例

## 项目模板

使用预设模板快速开始：

```bash
# Node.js项目
cp -r templates/node-project/* your-project/

# Python项目
cp -r templates/python-project/* your-project/

# Ruby项目
cp -r templates/ruby-project/* your-project/
```

## 配置

首次使用需要配置环境变量：

```bash
# 复制配置模板
cp config/env.example.json config/env.json

# 编辑配置
vim config/env.json
```

主要配置项：
- `PROJECT_NAME` - 项目名称
- `GITHUB_TOKEN` - GitHub访问令牌（可选）
- `DATABASE_URL` - 数据库连接（如需要）

## 验证安装

```bash
bash scripts/check_setup.sh
```

预期结果：16项检查全部通过 ✅

## 常见问题

**Q: 我迷路了，不知道该做什么？**
```bash
bash scripts/guide.sh
# 或在Claude中说"我迷路了"
```

**Q: 技能命令找不到？**
```bash
/find-skills
```

**Q: 需要帮助？**

查看 [故障排除文档](docs/故障排除.md) 或提交 [Issue](https://github.com/yourusername/harness_skill/issues)

## 贡献

欢迎贡献！请查看 [贡献指南](CONTRIBUTING.md)

## 许可证

MIT License - 详见 [LICENSE](LICENSE) 文件

## 致谢

灵感来源于 Harness Engineer 的工作方式，感谢所有贡献者！

---

**开始你的智能开发之旅** 🚀

有问题？运行 `bash scripts/guide.sh` 或在Claude中说"我需要帮助"
