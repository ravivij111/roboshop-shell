script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
dnf module disable mysql -y
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
yum install mysql-community-server -y
systemctl enable mysqld
systemctl start mysqld
mysql_secure_installation --set-root-pass RoboShop@1
#mysql -uroot -pRoboShop@1

echo -e "\e[32m********* Completed MySQL Steup Successfully ****************\e[0m"