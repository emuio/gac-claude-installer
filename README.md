# GAC Claude Code 一键安装器

快速安装并配置GAC版本的Claude Code，无需手动设置环境变量和API密钥。

## 🚀 一键安装

### 方法1：使用bash + 环境变量 (推荐)
```bash
GAC_API_KEY=sk-ant-oat01-xxxxxxx bash <(curl -fsSL https://raw.githubusercontent.com/emuio/gac-claude-installer/main/install_gac_claude.sh)
```

### 方法2：使用命令行参数
```bash
curl -fsSL https://raw.githubusercontent.com/emuio/gac-claude-installer/main/install_gac_claude.sh | bash -s sk-ant-oat01-xxxxxxx
```

### 方法3：下载后交互式运行
```bash
# 下载脚本
curl -fsSL https://raw.githubusercontent.com/emuio/gac-claude-installer/main/install_gac_claude.sh -o install_gac_claude.sh

# 添加执行权限
chmod +x install_gac_claude.sh

# 运行安装（会提示输入API密钥）
./install_gac_claude.sh
```

### 方法4：wget方式
```bash
# 使用环境变量
GAC_API_KEY=sk-ant-oat01-xxxxxxx bash <(wget -qO- https://raw.githubusercontent.com/emuio/gac-claude-installer/main/install_gac_claude.sh)
```

## 📋 安装内容

- ✅ 自动安装原版Claude Code
- ✅ 智能检测网络，国内用户自动使用镜像加速
- ✅ 配置GAC服务器地址 (`https://gaccode.com/claudecode`)
- ✅ 设置API密钥环境变量
- ✅ 自动批准API密钥（无需手动确认）
- ✅ 添加环境变量到shell配置文件

## 🔧 前置要求

- `jq` 工具（脚本会检查并提示安装）
- 有效的GAC API密钥 (以 `sk-ant-oat01-` 开头)

## 💡 使用说明

1. 运行安装脚本
2. 输入您的GAC API密钥
3. 重新加载shell配置或重启终端
4. 开始使用 `claude` 命令

## 🧪 验证安装

```bash
# 检查版本
claude --version

# 测试连接
claude "Hello, GAC Claude!"
```

## 🎯 获取GAC API密钥

还没有GAC账户？[点击注册GAC账户](https://gaccode.com/signup?ref=HBW1UC69) 获取您的API密钥。

## 📞 支持

如有问题，请访问 [GAC官网](https://gaccode.com) 或提交Issue。