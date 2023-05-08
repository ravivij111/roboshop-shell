script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y


sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf /etc/redis.conf
print_head "Replaced  Started Successfully "
systemctl enable redis
systemctl restart redis
print_head " Redis Started Successfully "