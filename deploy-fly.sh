#!/bin/bash
# Sub2API Fly.io 部署脚本

echo "=== Sub2API Fly.io 部署 ==="

# 1. 检查 Fly CLI
if ! command -v fly &> /dev/null; then
    echo "安装 Fly CLI..."
    # macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install flyctl
    # Windows
    elif [[ "$OSTYPE" == "msys" || "$OSTYPE" == "win32" ]]; then
        iwr https://fly.io/install.ps1 -OutFile install.ps1; powershell -ExecutionPolicy Bypass -File install.ps1; rm install.ps1
    # Linux
    else
        curl -L https://fly.io/install.sh | sh
    fi
fi

# 2. 登录
echo "请登录 Fly.io:"
fly auth login

# 3. 创建应用
echo "创建应用..."
fly launch --name sub2api --region sin --no-deploy

# 4. 创建 PostgreSQL 数据库
echo "创建 PostgreSQL 数据库..."
fly postgres create --name sub2api-db --region sin
fly postgres attach sub2api-db

# 5. 创建 Redis
echo "创建 Redis (使用 Upstash 免费方案)..."
# 或使用 fly.toml 中内置的 Redis (如果可用)

# 6. 设置必要的 secrets
echo "设置环境变量..."
echo "请设置 JWT_SECRET (运行以下命令):"
echo "fly secrets set JWT_SECRET=\$(openssl rand -hex 32)"

echo "请设置管理员密码:"
echo "fly secrets set ADMIN_PASSWORD=your_admin_password"

# 7. 部署
echo "部署应用..."
fly deploy

# 8. 查看状态
fly status

echo "=== 完成! ==="
echo "访问您的应用: fly apps list"