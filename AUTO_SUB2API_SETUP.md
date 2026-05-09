# AutoTeam + Sub2API 集成配置指南

## 概述

AutoTeam 支持同时同步账号到：
- CPA (CLIProxyAPI)
- Sub2API

## Sub2API 配置

### 1. 获取 Sub2API Admin API Key

登录 Sub2API 后台 → 设置 → API Keys → 创建新 API Key

或者在数据库中查找：
```sql
SELECT id, name, key FROM api_keys WHERE is_admin = true;
```

### 2. AutoTeam 配置

启动 AutoTeam 后，在 Web 面板 (http://localhost:8787) 的「设置」页面配置：

```
Sub2API 地址: https://your-sub2api-domain.com
Sub2API API Key: sk-xxx... (Admin API Key)
```

### 3. 默认账号设置（可选）

| 设置项 | 说明 | 默认值 |
|--------|------|--------|
| 并发 | 账号最大并发数 | 5 |
| 优先级 | 账号调度优先级 (越小越高) | 100 |
| 倍率 | 计费倍率 | 1.0 |
| 白名单 | 模型白名单 | * |
| WS | 是否启用 WebSocket | true |
| Passthrough | 是否启用透传 | false |

## API 对接详情

### Sub2API 账号创建 API

```
POST /api/v1/admin/accounts
Headers:
  Content-Type: application/json
  x-api-key: <admin-api-key>

Body:
{
  "name": "账号名称（邮箱）",
  "platform": "openai",
  "type": "oauth",
  "group_ids": [1, 2],
  "credentials": {
    "access_token": "eyJ...",
    "refresh_token": "rt_...",
    "expires_at": "2026-04-20T10:00:00Z"
  },
  "concurrency": 5,
  "priority": 100,
  "rate_multiplier": 1.0
}
```

### AutoTeam 同步流程

1. AutoTeam 执行 `rotate` 或 `sync` 命令
2. 遍历 active 状态的账号
3. 对每个账号调用 Sub2API 的 `/api/v1/admin/accounts` 接口
4. 自动创建或更新账号

## 手动测试

```bash
# 测试 Sub2API 连接
curl -X GET https://your-sub2api.com/api/v1/admin/accounts \
  -H "x-api-key: sk-your-key"

# 创建测试账号
curl -X POST https://your-sub2api.com/api/v1/admin/accounts \
  -H "Content-Type: application/json" \
  -H "x-api-key: sk-your-key" \
  -d '{
    "name": "test@example.com",
    "platform": "openai",
    "type": "oauth",
    "credentials": {
      "access_token": "test",
      "refresh_token": "test"
    }
  }'
```

## 故障排查

1. **同步失败**：检查 Sub2API 日志，验证 API Key 权限
2. **账号不生效**：确认 group_ids 正确，账号需要分配到分组
3. **Token 过期**：Sub2API 会自动刷新 OAuth Token

## 相关文档

- [Sub2API Admin API](https://github.com/Wei-Shaw/sub2api/blob/main/docs/ADMIN_PAYMENT_INTEGRATION_API.md)
- [AutoTeam 文档](https://github.com/cnitlrt/AutoTeam)