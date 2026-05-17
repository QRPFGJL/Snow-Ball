# RAG 知识库系统 - 小组实验指南

## 项目概述
本实验旨在构建一个基于 **OpenWebUI + Ollama + ChromaDB** 的检索增强生成（RAG）企业文档问答系统。

## 目录结构
```
rag-experiment/
├── docker-compose.yml    # Docker 编排文件
├── README.md             # 实验说明文档
├── docs/                 # 示例文档目录
│   └── 员工手册.md
├── config/               # 配置文件目录
└── scripts/              # 辅助脚本
    └── setup.sh          # 一键部署脚本
```

## 前置条件
- Docker 和 Docker Compose 已安装
- 至少 8GB 可用内存（推荐 16GB）
- 至少 20GB 可用磁盘空间

## 详细操作步骤

### 第一阶段：环境部署（预计 30-60 分钟）

#### 1.1 启动服务
```bash
cd /workspace/rag-experiment
chmod +x scripts/setup.sh
./scripts/setup.sh
```

或者手动执行：
```bash
# 启动所有服务
cd /workspace/rag-experiment
docker compose up -d

# 等待服务启动（约 10 秒）
sleep 10

# 下载模型
docker exec -it ollama ollama pull llama3:8b
docker exec -it ollama ollama pull nomic-embed-text
```

#### 1.2 验证服务状态
```bash
docker compose ps
```
确保所有容器状态为 `healthy` 或 `Up`

---

### 第二阶段：配置 OpenWebUI（预计 10-15 分钟）

#### 2.1 访问 OpenWebUI
打开浏览器访问：http://localhost:3000

#### 2.2 创建管理员账号
- 首次访问会提示注册
- 输入邮箱、用户名和密码
- 第一个注册的账号自动成为管理员

#### 2.3 配置 Ollama 连接
1. 登录后点击右上角头像 → **设置**
2. 进入 **模型** 选项卡
3. 在 **Ollama API 基础 URL** 中确认或填入：`http://ollama:11434`
4. 点击 **刷新模型列表**，应能看到 `llama3:8b` 和 `nomic-embed-text`

#### 2.4 配置 RAG 设置
1. 进入 **设置** → **知识库** 或 **RAG** 选项卡
2. 配置 ChromaDB 连接：`http://chromadb:8000`
3. 选择嵌入模型：`nomic-embed-text`

---

### 第三阶段：上传文档与测试（预计 20-30 分钟）

#### 3.1 上传文档
1. 在 OpenWebUI 界面找到 **知识库** 或 **文档** 功能
2. 点击 **上传文档**
3. 选择 `docs/` 目录下的示例文档（或上传自己的文档）
4. 支持格式：`.md`, `.txt`, `.pdf`, `.docx` 等

#### 3.2 测试问答
1. 新建一个聊天会话
2. 选择 `llama3:8b` 作为模型
3. 开启 **知识库检索** 或 **RAG** 开关
4. 提问示例问题：
   - "公司的工作时间是怎样的？"
   - "如何申请年假？"
   - "员工福利有哪些？"

---

### 第四阶段：实验扩展（可选）

#### 4.1 添加更多文档
将你的企业文档放入 `docs/` 目录并上传到系统

#### 4.2 尝试不同模型
```bash
docker exec -it ollama ollama pull mistral
docker exec -it ollama ollama pull qwen2:7b
```

#### 4.3 自定义 RAG 参数
- 调整检索的文档数量
- 调整相似度阈值
- 尝试不同的文本分块策略

---

## 常用命令

### 管理服务
```bash
# 查看服务状态
docker compose ps

# 查看日志
docker compose logs -f

# 停止服务
docker compose down

# 停止服务并删除数据（谨慎使用）
docker compose down -v
```

### Ollama 操作
```bash
# 进入 Ollama 容器
docker exec -it ollama bash

# 查看已安装模型
docker exec -it ollama ollama list

# 删除模型
docker exec -it ollama ollama rm <model-name>
```

---

## 小组分工建议

| 角色 | 任务 |
|------|------|
| 组长 | 整体协调、实验报告撰写 |
| 环境配置员 | Docker 环境部署、服务配置 |
| 数据处理员 | 文档收集、整理、测试 |
| 测试员 | 系统测试、问题记录、优化建议 |

---

## 实验报告要点

1. **系统架构**：说明各组件的作用和关系
2. **部署过程**：记录遇到的问题和解决方案
3. **功能测试**：展示问答效果截图和结果分析
4. **性能评估**：测试不同模型、参数下的表现
5. **总结与展望**：实验收获、不足之处、改进方向

---

## 下一步行动

1. 确保前置条件满足（Docker 已安装）
2. 运行 `./scripts/setup.sh` 开始部署
3. 按照上述步骤完成配置和测试
4. 记录实验过程，准备实验报告

---

## 故障排除

### 端口被占用
修改 `docker-compose.yml` 中的端口映射

### 模型下载慢
配置 Ollama 使用国内镜像源，或手动下载模型文件

### 内存不足
使用更小的模型（如 `llama3:8b` 改为 `llama3:8b-instruct-q4_0`）

---

## 技术支持
- OpenWebUI 文档：https://docs.openwebui.com
- Ollama 文档：https://ollama.ai/docs
- ChromaDB 文档：https://docs.trychroma.com
