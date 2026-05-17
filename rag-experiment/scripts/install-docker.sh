#!/bin/bash

echo "========================================="
echo "Docker 和 Docker Compose 安装脚本"
echo "========================================="
echo ""

# 检测操作系统
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$ID
    VERSION=$VERSION_ID
else
    echo "无法检测操作系统类型"
    exit 1
fi

echo "检测到操作系统: $OS $VERSION"
echo ""

case $OS in
    ubuntu|debian)
        echo "正在为 Debian/Ubuntu 系统安装 Docker..."
        
        # 更新包索引
        sudo apt-get update
        
        # 安装依赖
        sudo apt-get install -y ca-certificates curl gnupg lsb-release
        
        # 添加 Docker 官方 GPG 密钥
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/$OS/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        
        # 设置仓库
        echo \
          "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/$OS \
          $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        
        # 安装 Docker Engine
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        ;;
        
    centos|rhel|fedora)
        echo "正在为 CentOS/RHEL/Fedora 系统安装 Docker..."
        
        # 安装依赖
        sudo yum install -y yum-utils
        
        # 设置仓库
        sudo yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
        
        # 安装 Docker Engine
        sudo yum install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
        
        ;;
        
    *)
        echo "不支持的操作系统: $OS"
        echo "请访问 https://docs.docker.com/engine/install/ 手动安装"
        exit 1
        ;;
esac

echo ""
echo "启动 Docker 服务..."
sudo systemctl start docker
sudo systemctl enable docker

echo ""
echo "将当前用户添加到 docker 组..."
sudo usermod -aG docker $USER

echo ""
echo "========================================="
echo "安装完成！"
echo "========================================="
echo ""
echo "请执行以下命令使组更改生效："
echo "  newgrp docker"
echo ""
echo "或者注销并重新登录"
echo ""
echo "验证安装："
echo "  docker --version"
echo "  docker compose version"
echo ""
