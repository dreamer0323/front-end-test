#!/usr/bin/env bash
# 在【本地 Windows】执行：把 demo 上传到服务器。
# 需要先用两个环境变量填入你的服务器信息，例如：
#   SERVER_USER=ubuntu SERVER_IP=1.2.3.4 bash deploy-local.sh
set -euo pipefail

: "${SERVER_USER:?请设置服务器用户名，如 SERVER_USER=ubuntu}"
: "${SERVER_IP:?请设置服务器公网 IP，如 SERVER_IP=1.2.3.4}"

# 要上传的项目根目录（相对本脚本所在目录）
LOCAL_SRC="$(cd "$(dirname "$0")/.." && pwd)"
REMOTE_DEST="/var/www/front-end-test"

echo "==> 上传项目文件到服务器 ${SERVER_USER}@${SERVER_IP}"
# 只传网页文件，跳过 deploy 目录和无关文件
scp -r "$LOCAL_SRC"/demo1.html "$LOCAL_SRC"/demo1.css "$LOCAL_SRC"/demo1.js \
    "${SERVER_USER}@${SERVER_IP}:${REMOTE_DEST}/"

echo ""
echo "上传完成！"
echo "浏览器访问: http://${SERVER_IP}/demo1.html"
echo "（如无法访问，通常是防火墙/安全组未放行 80 端口，或 Nginx 未启动）"
