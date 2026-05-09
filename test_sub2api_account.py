#!/usr/bin/env python3
"""
Sub2API 账号同步测试脚本
用于验证 AutoTeam -> Sub2API 集成
"""

import requests
import json
import sys
from datetime import datetime, timedelta

# 配置
SUB2API_URL = "http://localhost:8080"  # 改为你的 Sub2API 地址
ADMIN_API_KEY = "sk-your-admin-key"   # 改为你的 Admin API Key

def test_connection():
    """测试 Sub2API 连接"""
    print("=== 测试 Sub2API 连接 ===")
    
    headers = {"x-api-key": ADMIN_API_KEY}
    
    try:
        # 获取账号列表
        resp = requests.get(
            f"{SUB2API_URL}/api/v1/admin/accounts",
            headers=headers,
            timeout=10
        )
        print(f"状态码: {resp.status_code}")
        
        if resp.status_code == 200:
            data = resp.json()
            count = data.get("total", len(data.get("accounts", [])))
            print(f"✅ 连接成功! 当前账号数: {count}")
            return True
        else:
            print(f"❌ 连接失败: {resp.text}")
            return False
    except Exception as e:
        print(f"❌ 连接错误: {e}")
        return False

def create_test_account():
    """创建测试账号"""
    print("\n=== 创建测试账号 ===")
    
    headers = {
        "Content-Type": "application/json",
        "x-api-key": ADMIN_API_KEY
    }
    
    # 模拟 AutoTeam 同步的账号数据
    test_account = {
        "name": f"test-autoteam-{datetime.now().strftime('%Y%m%d%H%M%S')}@example.com",
        "platform": "openai",
        "type": "oauth",
        "credentials": {
            "access_token": "mock-access-token-from-autoteam",
            "refresh_token": "mock-refresh-token",
            "expires_at": (datetime.now() + timedelta(days=30)).isoformat() + "Z"
        },
        "concurrency": 5,
        "priority": 100,
        "rate_multiplier": 1.0
    }
    
    try:
        resp = requests.post(
            f"{SUB2API_URL}/api/v1/admin/accounts",
            headers=headers,
            json=test_account,
            timeout=10
        )
        
        print(f"状态码: {resp.status_code}")
        
        if resp.status_code in [200, 201]:
            data = resp.json()
            account_id = data.get("id") or data.get("account", {}).get("id")
            print(f"✅ 账号创建成功! ID: {account_id}")
            return account_id
        else:
            print(f"❌ 创建失败: {resp.text}")
            return None
    except Exception as e:
        print(f"❌ 创建错误: {e}")
        return None

def get_groups():
    """获取分组列表"""
    print("\n=== 获取分组列表 ===")
    
    headers = {"x-api-key": ADMIN_API_KEY}
    
    try:
        resp = requests.get(
            f"{SUB2API_URL}/api/v1/admin/groups",
            headers=headers,
            timeout=10
        )
        
        if resp.status_code == 200:
            data = resp.json()
            groups = data.get("groups", data)
            print(f"✅ 找到 {len(groups)} 个分组:")
            for g in groups[:5]:  # 只显示前5个
                print(f"  - ID: {g.get('id')}, Name: {g.get('name')}")
            return groups
        else:
            print(f"❌ 获取分组失败: {resp.text}")
            return []
    except Exception as e:
        print(f"❌ 获取分组错误: {e}")
        return []

def main():
    print("Sub2API 账号同步测试工具")
    print("=" * 40)
    
    # 测试连接
    if not test_connection():
        print("\n❌ 请检查 Sub2API 地址和 API Key 配置")
        sys.exit(1)
    
    # 获取分组
    groups = get_groups()
    
    # 创建测试账号
    account_id = create_test_account()
    
    print("\n=== 测试完成 ===")
    print(f"Sub2API 地址: {SUB2API_URL}")
    print(f"API Key: {ADMIN_API_KEY[:20]}...")

if __name__ == "__main__":
    main()