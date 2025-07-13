#!/bin/bash

# GAC Claude Code 一键安装脚本
# 作用：安装原版Claude Code并配置为使用GAC第三方服务

set -e  # 遇到错误立即退出

echo "🚀 开始安装GAC Claude Code..."

# 检查是否已安装jq
if ! command -v jq &> /dev/null; then
    echo "❌ 错误：需要安装jq工具"
    echo "请先安装jq："
    echo "  macOS: brew install jq"
    echo "  Ubuntu/Debian: sudo apt-get install jq"
    echo "  CentOS/RHEL: sudo yum install jq"
    exit 1
fi

# 获取API密钥
if [[ -n "$GAC_API_KEY" ]]; then
    api_key="$GAC_API_KEY"
    echo "✅ 使用环境变量中的API密钥"
    echo "🔍 检测到的密钥前缀: ${api_key:0:15}..."
else
    read -p "请输入您的GAC API密钥 (sk-ant-oat01-...): " api_key
fi

if [[ -z "$api_key" ]]; then
    echo "❌ API密钥不能为空"
    exit 1
fi

# 检查API密钥格式 - 支持更灵活的格式
if [[ ! $api_key =~ ^sk-ant- ]]; then
    echo "❌ API密钥格式不正确，应该以 'sk-ant-' 开头"
    echo "🔍 当前密钥前缀: ${api_key:0:15}..."
    echo "💡 提示：您可以通过环境变量传入密钥："
    echo "   GAC_API_KEY=sk-ant-oat01-xxxxx curl -fsSL https://raw.githubusercontent.com/emuio/gac-claude-installer/main/install_gac_claude.sh | bash"
    exit 1
fi

echo "📦 安装原版Claude Code..."
# 安装Claude Code - 使用正确的包名，支持国内镜像加速
if command -v npm &> /dev/null; then
    echo "🔧 使用npm安装Claude Code..."
    
    # 检测是否在中国，使用国内镜像加速
    if curl -s --connect-timeout 3 https://registry.npmjs.org/ > /dev/null 2>&1; then
        echo "🌍 使用官方npm镜像..."
        npm install -g @anthropic-ai/claude-code
    else
        echo "🇨🇳 检测到网络较慢，使用国内镜像加速..."
        npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com
    fi
    
    if [ $? -ne 0 ]; then
        echo "❌ npm安装失败，尝试使用国内镜像..."
        npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com
        if [ $? -ne 0 ]; then
            echo "❌ 安装失败，请检查网络连接或npm权限"
            echo "💡 可能需要使用sudo权限："
            echo "   sudo npm install -g @anthropic-ai/claude-code --registry=https://registry.npmmirror.com"
            exit 1
        fi
    fi
else
    echo "❌ 需要npm来安装Claude Code"
    echo "请先安装Node.js和npm："
    echo "  访问: https://nodejs.org/"
    echo "  或使用包管理器安装"
    exit 1
fi

echo "🔧 配置环境变量..."

# 设置环境变量到用户的shell配置文件
shell_config=""
if [[ $SHELL == *"zsh"* ]]; then
    shell_config="$HOME/.zshrc"
elif [[ $SHELL == *"bash"* ]]; then
    shell_config="$HOME/.bashrc"
else
    shell_config="$HOME/.profile"
fi

# 添加环境变量到shell配置
echo "" >> "$shell_config"
echo "# GAC Claude Code 配置" >> "$shell_config"
echo "export ANTHROPIC_BASE_URL=https://gaccode.com/claudecode" >> "$shell_config"
echo "export ANTHROPIC_API_KEY=$api_key" >> "$shell_config"

# 在当前session中也设置环境变量
export ANTHROPIC_BASE_URL=https://gaccode.com/claudecode
export ANTHROPIC_API_KEY=$api_key

echo "🔑 配置API密钥自动批准..."

# 程序化批准API密钥
(cat ~/.claude.json 2>/dev/null || echo 'null') | jq --arg key "${ANTHROPIC_API_KEY: -20}" '(. // {}) | .customApiKeyResponses.approved |= ([.[]?, $key] | unique)' > ~/.claude.json.tmp && mv ~/.claude.json.tmp ~/.claude.json

echo "✅ 安装完成！"
echo ""
echo "📋 配置摘要："
echo "  - 基础URL: https://gaccode.com/claudecode"
echo "  - API密钥已配置并自动批准"
echo "  - 环境变量已添加到: $shell_config"
echo ""
echo "🔄 请运行以下命令使配置生效："
echo "  source $shell_config"
echo ""
echo "或者重新打开终端窗口"
echo ""
echo "🧪 测试安装："
echo "  claude --version"