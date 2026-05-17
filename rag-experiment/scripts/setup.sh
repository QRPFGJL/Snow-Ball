#!/bin/bash

echo "========================================="
echo "RAG 实验环境部署脚本"
echo "========================================="

# 检查 Docker 是否安装
if ! command -v docker &> /dev/null; then
    echo "错误: Docker 未安装，请先安装 Docker"
    exit 1
fi

# 检查 Docker Compose 是否安装
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    echo "错误: Docker Compose 未安装，请先安装 Docker Compose"
    exit 1
fi

echo ""
echo "步骤 1: 启动所有服务..."
cd "$(dirname "$0")/.." || exit 1

if docker compose version &> /dev/null; then
    docker compose up -d
else
    docker-compose up -d
fi

echo ""
echo "等待服务启动..."
sleep 10

echo ""
echo "步骤 2: 下载 Ollama 模型..."
echo "正在下载 llama3:8b 和 nomic-embed-text..."

docker exec -it ollama ollama pull llama3:8b
docker exec -it ollama ollama pull nomic-embed-text

echo ""
echo "========================================="
echo "部署完成！"
echo "========================================="
echo ""
echo "服务访问地址："
echo "  OpenWebUI: http://localhost:3000"
echo "  Ollama API: http://localhost:11434"
echo "  ChromaDB: http://localhost:8000"
echo ""
echo "下一步操作："
echo "1. 打开浏览器访问 http://localhost:3000"
echo "2. 创建第一个管理员账号"
echo "3. 在设置中配置 Ollama 和 ChromaDB"
echo "4. 上传文档开始使用 RAG 功能"
echo ""
