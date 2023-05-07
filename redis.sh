yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y
dnf module enable redis:remi-6.2 -y
yum install redis -y


sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf /etc/redis.conf
echo -e "\e[32m********* Replaced  Started Successfully ****************\e[0m"
systemctl enable redis
systemctl restart redis
echo -e "\e[32m********* Redis Started Successfully ****************\e[0m"