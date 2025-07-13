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

# 提示用户输入API密钥
read -p "请输入您的GAC API密钥 (sk-ant-oat01-...): " api_key

if [[ ! $api_key =~ ^sk-ant-oat01- ]]; then
    echo "❌ API密钥格式不正确，应该以 'sk-ant-oat01-' 开头"
    exit 1
fi

echo "📦 安装原版Claude Code..."
# 安装Claude Code (假设使用npm/curl安装，您可能需要根据实际情况调整)
if command -v npm &> /dev/null; then
    npm install -g @anthropic/claude-code
elif command -v curl &> /dev/null; then
    # 如果有其他安装方式，在这里添加
    echo "请手动安装Claude Code或确保已安装"
else
    echo "❌ 无法自动安装Claude Code，请手动安装后重新运行此脚本"
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