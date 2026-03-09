# 示例：简单 REST API

> 使用 Claude 技能库从零开发一个 REST API

## 项目概述

这是一个使用 Claude 技能库开发的简单任务管理 API 示例。

### 技术栈

- Node.js + Express
- MongoDB
- Jest (测试)

### 功能

- 用户认证（JWT）
- 任务 CRUD
- 任务分配
- 任务状态管理

## 开发流程

### 1. 项目初始化

```bash
# 初始化项目
bash ../../scripts/init_project.sh

# 验证配置
bash ../../scripts/check_setup.sh
```

### 2. 需求分析

在 Claude 中运行：

```
/brainstorming
```

**问答过程**：

```
Q: 项目要解决什么问题？
A: 构建一个简单的任务管理 API

Q: 目标用户是谁？
A: 开发者，用于学习和参考

Q: 有什么技术约束？
A: 使用 Node.js + Express + MongoDB

Q: 成功标准是什么？
A: 实现基本的 CRUD 操作和用户认证
```

**设计方案**：

选择了简单快速的方案：
- Express 作为 Web 框架
- MongoDB 作为数据库
- JWT 用于认证
- Jest 用于测试

### 3. 创建计划

```
/writing-plans
```

生成的任务清单：

- [x] 项目初始化
- [x] 数据库模型设计
- [x] 用户认证 API
- [x] 任务 CRUD API
- [x] 单元测试
- [x] 集成测试
- [x] API 文档

### 4. 开发功能

#### 4.1 数据库模型

```javascript
// src/models/User.js
const mongoose = require('mongoose');

const userSchema = new mongoose.Schema({
  email: { type: String, required: true, unique: true },
  password: { type: String, required: true },
  name: String,
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('User', userSchema);
```

```javascript
// src/models/Task.js
const mongoose = require('mongoose');

const taskSchema = new mongoose.Schema({
  title: { type: String, required: true },
  description: String,
  status: { 
    type: String, 
    enum: ['todo', 'in_progress', 'done'],
    default: 'todo'
  },
  assignee: { type: mongoose.Schema.Types.ObjectId, ref: 'User' },
  createdAt: { type: Date, default: Date.now },
  updatedAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Task', taskSchema);
```

#### 4.2 认证 API

```javascript
// src/routes/auth.js
const express = require('express');
const jwt = require('jsonwebtoken');
const bcrypt = require('bcrypt');
const User = require('../models/User');

const router = express.Router();

// 注册
router.post('/register', async (req, res) => {
  try {
    const { email, password, name } = req.body;
    
    // 检查用户是否存在
    const existingUser = await User.findOne({ email });
    if (existingUser) {
      return res.status(400).json({ error: '用户已存在' });
    }
    
    // 加密密码
    const hashedPassword = await bcrypt.hash(password, 10);
    
    // 创建用户
    const user = await User.create({
      email,
      password: hashedPassword,
      name
    });
    
    res.status(201).json({ 
      id: user._id, 
      email: user.email, 
      name: user.name 
    });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 登录
router.post('/login', async (req, res) => {
  try {
    const { email, password } = req.body;
    
    // 查找用户
    const user = await User.findOne({ email });
    if (!user) {
      return res.status(401).json({ error: '用户名或密码错误' });
    }
    
    // 验证密码
    const isValid = await bcrypt.compare(password, user.password);
    if (!isValid) {
      return res.status(401).json({ error: '用户名或密码错误' });
    }
    
    // 生成 token
    const token = jwt.sign(
      { userId: user._id },
      process.env.JWT_SECRET,
      { expiresIn: '7d' }
    );
    
    res.json({ token });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

#### 4.3 任务 API

```javascript
// src/routes/tasks.js
const express = require('express');
const Task = require('../models/Task');
const auth = require('../middleware/auth');

const router = express.Router();

// 所有路由都需要认证
router.use(auth);

// 获取所有任务
router.get('/', async (req, res) => {
  try {
    const tasks = await Task.find().populate('assignee', 'name email');
    res.json(tasks);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 创建任务
router.post('/', async (req, res) => {
  try {
    const task = await Task.create(req.body);
    res.status(201).json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 获取单个任务
router.get('/:id', async (req, res) => {
  try {
    const task = await Task.findById(req.params.id)
      .populate('assignee', 'name email');
    
    if (!task) {
      return res.status(404).json({ error: '任务不存在' });
    }
    
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 更新任务
router.put('/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndUpdate(
      req.params.id,
      { ...req.body, updatedAt: Date.now() },
      { new: true }
    );
    
    if (!task) {
      return res.status(404).json({ error: '任务不存在' });
    }
    
    res.json(task);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

// 删除任务
router.delete('/:id', async (req, res) => {
  try {
    const task = await Task.findByIdAndDelete(req.params.id);
    
    if (!task) {
      return res.status(404).json({ error: '任务不存在' });
    }
    
    res.json({ message: '任务已删除' });
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

module.exports = router;
```

### 5. 测试

#### 5.1 单元测试

```javascript
// tests/models/Task.test.js
const Task = require('../../src/models/Task');

describe('Task Model', () => {
  it('should create a task with required fields', () => {
    const task = new Task({
      title: 'Test Task'
    });
    
    expect(task.title).toBe('Test Task');
    expect(task.status).toBe('todo');
  });
  
  it('should validate status enum', () => {
    const task = new Task({
      title: 'Test Task',
      status: 'invalid'
    });
    
    const error = task.validateSync();
    expect(error).toBeDefined();
  });
});
```

#### 5.2 集成测试

```javascript
// tests/routes/tasks.test.js
const request = require('supertest');
const app = require('../../src/app');

describe('Task API', () => {
  let token;
  
  beforeAll(async () => {
    // 登录获取 token
    const response = await request(app)
      .post('/api/auth/login')
      .send({ email: 'test@example.com', password: 'password' });
    
    token = response.body.token;
  });
  
  it('should create a new task', async () => {
    const response = await request(app)
      .post('/api/tasks')
      .set('Authorization', `Bearer ${token}`)
      .send({ title: 'Test Task' });
    
    expect(response.status).toBe(201);
    expect(response.body.title).toBe('Test Task');
  });
  
  it('should get all tasks', async () => {
    const response = await request(app)
      .get('/api/tasks')
      .set('Authorization', `Bearer ${token}`);
    
    expect(response.status).toBe(200);
    expect(Array.isArray(response.body)).toBe(true);
  });
});
```

### 6. 代码审查

```
/requesting-code-review
```

审查结果：
- ✅ 代码结构清晰
- ✅ 错误处理完善
- ✅ 测试覆盖充分
- ⚠️ 建议：添加输入验证
- ⚠️ 建议：添加速率限制

### 7. 完成验证

```
/verification-before-completion
```

检查清单：
- [x] 所有测试通过
- [x] 代码审查完成
- [x] API 文档已更新
- [x] README 已更新

## 运行项目

### 安装依赖

```bash
npm install
```

### 配置环境变量

```bash
cp .env.example .env
# 编辑 .env 文件
```

### 启动服务

```bash
# 开发模式
npm run dev

# 生产模式
npm start
```

### 运行测试

```bash
# 所有测试
npm test

# 带覆盖率
npm test -- --coverage

# 监听模式
npm test -- --watch
```

## API 文档

### 认证

#### 注册

```
POST /api/auth/register
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123",
  "name": "User Name"
}
```

#### 登录

```
POST /api/auth/login
Content-Type: application/json

{
  "email": "user@example.com",
  "password": "password123"
}

Response:
{
  "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
}
```

### 任务

所有任务 API 需要在 Header 中包含 token：

```
Authorization: Bearer <token>
```

#### 获取所有任务

```
GET /api/tasks
```

#### 创建任务

```
POST /api/tasks
Content-Type: application/json

{
  "title": "Task Title",
  "description": "Task Description",
  "status": "todo",
  "assignee": "user_id"
}
```

#### 获取单个任务

```
GET /api/tasks/:id
```

#### 更新任务

```
PUT /api/tasks/:id
Content-Type: application/json

{
  "title": "Updated Title",
  "status": "in_progress"
}
```

#### 删除任务

```
DELETE /api/tasks/:id
```

## 学到的经验

### 使用技能库的好处

1. **结构化流程**：从需求到部署，每一步都有指引
2. **自动化检查**：提交前自动运行测试和代码检查
3. **最佳实践**：内置 TDD、代码审查等最佳实践
4. **文档自动化**：自动更新文档和变更日志

### 改进建议

1. 添加输入验证（使用 Joi 或 express-validator）
2. 添加速率限制（使用 express-rate-limit）
3. 添加日志系统（使用 winston）
4. 添加 API 版本控制
5. 添加 Swagger 文档

## 下一步

- 查看 [完整指南](../../docs/完整指南.md) 了解更多功能
- 查看 [最佳实践](../../docs/最佳实践.md) 学习技巧
- 尝试开发更复杂的功能

---

**示例版本**：1.0
**创建日期**：2026-03-09
