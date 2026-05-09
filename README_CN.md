# TOPGO Platform

<div align="center">

[![Go](https://img.shields.io/badge/Go-1.25.7-00ADD8.svg)](https://golang.org/)
[![Vue](https://img.shields.io/badge/Vue-3.4+-4FC08D.svg)](https://vuejs.org/)
[![Python](https://img.shields.io/badge/Python-3.10+-3776AB.svg)](https://python.org)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15+-336791.svg)](https://www.postgresql.org/)
[![Redis](https://img.shields.io/badge/Redis-7+-DC382D.svg)](https://redis.io/)
[![Docker](https://img.shields.io/badge/Docker-Ready-2496ED.svg)](https://www.docker.com/)

**一体化 AI 资源管理平台**

[English](README.md) | 中文

</div>

---

## 项目概述

TOPGO Platform 是企业级一体化 AI 资源管理平台，整合了 **智能调度引擎** 与 **统一API网关** 两大核心组件，为企业提供完整的 AI 资源供给与管理解决方案。

### 核心架构

```
┌─────────────────────────────────────────────────────────┐
│                   TOPGO Platform                        │
├─────────────────────────────────────────────────────────┤
│  ┌─────────────────────┐    ┌─────────────────────────┐ │
│  │  TOPGO Orchestrator │───→│   TOPGO Gateway        │ │
│  │    (调度引擎)       │    │     (统一网关)          │ │
│  │                     │    │                         │ │
│  │ • 资源自动注册      │    │ • 智能路由              │ │
│  │ • 健康探测与轮转    │    │ • 精准计费              │ │
│  │ • 多维标签管理      │    │ • 用户管理              │ │
│  │ • 策略编排          │    │ • 负载均衡              │ │
│  └─────────────────────┘    └─────────────────────────┘ │
└─────────────────────────────────────────────────────────┘
```

| 组件 | 技术栈 | 功能 |
|------|--------|------|
| **Gateway** | Go + Vue | API 网关、计费、用户管理 |
| **Orchestrator** | Python + Vue | 资源调度、轮转、同步 |

## 快速部署

### Docker Compose (推荐)

```bash
# 克隆项目
git clone https://gitee.com/anbeime/api-token.git
cd api-token

# 启动完整平台 (Gateway + Orchestrator)
docker compose up -d
```

访问 http://localhost:8080 (Gateway) 和 http://localhost:8787 (Orchestrator)

### 分别部署

**Gateway (API 网关):**
```bash
cd backend
docker compose up -d
```

**Orchestrator (调度引擎):**
```bash
cd orchestrator
docker compose up -d
```

## 核心功能

### TOPGO Gateway (统一API网关)
- **多模型支持** - Claude、OpenAI (Codex)、Gemini
- **资源凭证管理** - OAuth、API Key
- **精准计费** - 用量级别追踪
- **智能路由** - 基于 GEO 的动态路由
- **用户管理** - API Key、套餐、充值

### TOPGO Orchestrator (智能调度引擎)
- **自动注册** - 自动创建 AI 账号
- **智能轮转** - 按可用量自动调度
- **健康探测** - 实时监控资源状态
- **策略编排** - 多维度路由策略
- **Gateway 同步** - 自动推送资源到网关

## 资源供给流程

```
1. [Orchestrator] 自动注册/管理 AI 资源
         ↓
2. [Orchestrator] 探测资源健康度，打标签
         ↓
3. [Orchestrator] 同步资源到 Gateway
         ↓
4. [Gateway] 接收资源，提供 API 服务
         ↓
5. [用户] 通过 API Key 调用 AI 服务
```

## 项目结构

```
api-token/
├── backend/              # TOPGO Gateway (Go)
│   ├── cmd/server/       # 主入口
│   ├── internal/         # 核心逻辑
│   ├── frontend/         # Vue 前端
│   └── deploy/           # 部署配置
│
├── orchestrator/         # TOPGO Orchestrator (Python)
│   ├── src/              # 核心逻辑
│   ├── web/              # Vue 前端
│   └── docs/             # 文档
│
├── docs/                 # 公共文档
├── deploy/               # 公共部署配置
└── docker-compose.yml    # 一体化部署
```

## 环境配置

### Gateway 环境变量
| 变量 | 说明 | 默认值 |
|------|------|--------|
| `DATABASE_URL` | PostgreSQL | postgres://... |
| `REDIS_URL` | Redis | redis://... |
| `JWT_SECRET` | JWT 密钥 | 自动生成 |
| `AUTO_SETUP` | 自动初始化 | true |

### Orchestrator 环境变量
| 变量 | 说明 |
|------|------|
| `TOPGO_GATEWAY_URL` | Gateway API 地址 |
| `TOPGO_GATEWAY_API_KEY` | Gateway 管理密钥 |
| `MAIL_PROVIDER` | 邮箱服务配置 |

## 术语对照

| 旧术语 | 新术语 |
|--------|--------|
| 账号 | 资源实例 |
| 订阅 | 资源包 |
| 额度 | 可用量 |
| 轮转 | 资源调度 |
| 拼车 | 资源池 |

## 文档

- [GEO 智能路由架构](TOPGO_GEO_ARCHITECTURE.md)
- [Gateway 部署指南](backend/deploy/README.md)
- [Orchestrator 配置说明](orchestrator/docs/configuration.md)

## 许可证

GNU Lesser General Public License v3.0 (LGPL-3.0)

---

**TOPGO Platform** - 您的企业级 AI 资源管理解决方案