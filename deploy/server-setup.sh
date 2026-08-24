#!/usr/bin/env bash
# 在云服务器上执行的一次性初始化脚本。
# 作用：安装 Nginx、创建网站目录、放入默认配置、设为开机自启。
# 用法：以 root 或 sudo 在服务器上执行  sudo bash server-setup.sh

set -e

echo "==> 1/4 更新软件源并安装 Nginx"
if command -v apt-get >/dev/null 2>&1; then
    export DEBIAN_FRONTEND=noninteractive
    apt-get update -y
    apt-get install -y nginx git
else
    # 兼容 CentOS / Rocky / Alma
    yum install -y nginx git || dnf install -y nginx git
fi

echo "==> 2/4 创建网站根目录"
mkdir -p /var/www/front-end-test

echo "==> 3/4 写入 Nginx 配置并启用"
# 复制默认配置模板（与项目里的 nginx-static.conf 保持一致）
cp "$(dirname "$0")/nginx-static.conf" /etc/nginx/sites-available/front-end-test

# Debian/Ubuntu 需要建立 sites-enabled 软链；RHEL 系用 conf.d
if [ -d /etc/nginx/sites-enabled ]; then
    ln -sf /etc/nginx/sites-available/front-end-test /etc/nginx/sites-enabled/front-end-test
    rm -f /etc/nginx/sites-enabled/default
elif [ -d /etc/nginx/conf.d ]; then
    cp /etc/nginx/sites-available/front-end-test /etc/nginx/conf.d/front-end-test.conf
fi

echo "==> 4/4 测试配置并重启 Nginx"
nginx -t
systemctl enable nginx
systemctl restart nginx

echo ""
echo "初始化完成！把前端文件放到 /var/www/front-end-test/ 即可通过公网 IP 访问。"
