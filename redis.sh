script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

func_print_head " Installing Redis"
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>> /tmp/roboshop.log
func_stat_check $?
dnf module enable redis:remi-6.2 -y
yum install redis -y

func_print_head " Replacing 127.0.0.1 by 0.0.0.0 in /etc/redis/redis.conf /etc/redis.conf"
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/redis/redis.conf /etc/redis.conf &>> /tmp/roboshop.log
func_stat_check $?
func_print_head "Replaced  Started Successfully "
systemctl enable redis
systemctl restart redis &>> /tmp/roboshop.log
func_stat_check $?



func_print_head " Redis Started and confirm by systemctl status redis "