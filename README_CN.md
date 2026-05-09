# TOPGO Gateway

<div align="center">

[![Go](https://img.shields.io/badge/Go-1.25.7-00ADD8.svg)](https://golang.org/)
[![Vue](https://img.shields.io/badge/Vue-3.4+-4FC08D.svg)](https://vuejs.org/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7+-DC382D.svg)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)

**企业级 AI API 管理平台**

[English](README.md) | 中文 | [日本語](README_JA.md)

</div>

---

## 项目概述

TOPGO Gateway 是企业级 AI API 管理平台，用于分发和管理 AI 模型服务的 API 配额。用户通过平台生成的 API Key 调用上游 AI 服务，平台负责鉴权、用量计量、负载均衡和请求转发。

### 核心定位

> TOPGO Gateway（统一API网关）负责对外提供稳定、可计量的企业级 API 服务。
> 
> 配合 [TOPGO Orchestrator](https://github.com/anbeime/topgo-orchestrator)（智能调度引擎），二者共同构成 TOPGO 平台的核心，实现 AI 模型资源的自动化供给与管理。

## 核心功能

- **多模型支持** - 支持 Claude、OpenAI (Codex)、Gemini 等主流 AI 模型
- **资源凭证管理** - 支持多种上游凭证类型（OAuth、API Key）
- **精准计费** - 用量级别的消耗追踪和成本分析
- **智能路由** - 智能资源实例选择，支持会话保持
- **并发控制** - 用户级和资源级并发限制
- **速率限制** - 可配置的请求和用量速率限制
- **内置支付系统** - 支持 EasyPay、支付宝、微信支付、Stripe，用户自助充值
- **管理后台** - Web 界面进行监控和管理
- **外部系统集成** - 支持通过 iframe 嵌入外部系统，扩展管理功能

## 架构优势

| 特性 | 说明 |
|------|------|
| 高可用 | 多实例部署，负载均衡 |
| 精准计费 | 实时用量统计，按量计费 |
| 灵活扩展 | 支持横向扩展，按需扩容 |
| 安全可靠 | 完善的鉴权和加密机制 |

## 快速部署

### Docker Compose（推荐）

```bash
# 克隆项目
git clone https://github.com/anbeime/api-token.git
cd api-token

# 启动服务
docker compose up -d
```

访问 http://localhost:8080 完成初始配置。

### 环境配置

主要环境变量：

| 变量 | 说明 | 默认值 |
|------|------|--------|
| `DATABASE_HOST` | PostgreSQL 地址 | postgres |
| `REDIS_HOST` | Redis 地址 | redis |
| `JWT_SECRET` | JWT 密钥 | 自动生成 |
| `AUTO_SETUP` | 自动初始化 | true |

## 资源供给

TOPGO Gateway 支持与 TOPGO Orchestrator 无缝集成，实现资源的自动化供给。

### 配置步骤

1. 在 TOPGO Orchestrator 中配置同步目标为 Gateway 的管理员 API 地址
2. 在 Gateway 后台创建对应的资源分组
3. Orchestrator 会自动将资源实例同步到 Gateway

### API 对接

```
POST /api/v1/admin/accounts
Headers:
  x-api-key: <admin-api-key>

Body:
{
  "name": "资源实例名称",
  "platform": "openai",
  "type": "oauth",
  "group_ids": [1, 2],
  "credentials": {
    "access_token": "...",
    "refresh_token": "..."
  }
}
```

## 术语对照

| 旧术语 | 新术语 |
|--------|--------|
| 订阅 | 资源包 |
| 账号 | 资源实例 |
| 拼车 | 资源池 |
| Token中转 | API 代理 |
| Token计费 | 用量计量 |

## 相关项目

- [TOPGO Orchestrator](https://github.com/anbeime/topgo-orchestrator) - 智能调度引擎，负责自动化管理与供给 AI 模型资源

## 许可证

GNU Lesser General Public License v3.0 (LGPL-3.0)

---

**TOPGO Gateway** - 您的企业级 AI API 管理解决方案