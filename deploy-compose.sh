#!/bin/bash
# Sub2API + AutoTeam 完整部署脚本
# 支持 Fly.io 部署

echo "========================================"
echo "Sub2API + AutoTeam 一键部署脚本"
echo "========================================"

# 检查 Fly CLI
if ! command -v fly &> /dev/null; then
    echo "安装 Fly CLI..."
    curl -L https://fly.io/install.sh | sh
fi

# 1. 部署 sub2api (API 网关)
echo "[1/4] 部署 sub2api API 网关..."
fly launch --name sub2api --region sin --no-deploy --org personal

# 创建 PostgreSQL
echo "[2/4] 创建 PostgreSQL 数据库..."
fly postgres create --name sub2api-db --region sin --vm-size shared-vm --volume-size 1
fly postgres attach sub2api-db --app sub2api

# 设置环境变量
echo "[3/4] 设置环境变量..."
# 生成随机密钥
JWT_SECRET=$(openssl rand -hex 32)

fly secrets set JWT_SECRET="$JWT_SECRET" --app sub2api
fly secrets set ADMIN_PASSWORD=admin123456 --app sub2api
fly secrets set AUTO_SETUP=true --app sub2api
fly secrets set SERVER_MODE=release --app sub2api

# 部署
fly deploy --app sub2api

echo "========================================"
echo "sub2api 部署完成!"
echo "访问地址: https://sub2api.fly.dev"
echo "========================================"

# 2. 部署 AutoTeam (账号管理)
echo "[4/4] 部署 AutoTeam..."
# 注意: AutoTeam 需要单独仓库，这里只是部署说明
echo ""
echo "AutoTeam 需要单独部署:"
echo "1. git clone https://github.com/cnitlrt/AutoTeam.git"
echo "2. cd AutoTeam"
echo "3. 创建 fly.toml 并配置"
echo "4. fly deploy"
echo ""
echo "或在 Docker 上运行:"
echo "mkdir -p autoteam-data && cd autoteam-data"
echo "curl -sSL https://raw.githubusercontent.com/cnitlrt/AutoTeam/main/docker-compose.yml > docker-compose.yml"
echo "cp .env.example .env  # 编辑配置"
echo "docker compose up -d"

echo "========================================"
echo "部署完成!"
echo "========================================"