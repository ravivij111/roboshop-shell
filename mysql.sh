script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1
if [ -z "$mysql_root_password" ]
then
  echo Input mySQL password is missing
  exit
fi


dnf module disable mysql -y /tmp/roboshop.log
cp ${script_path}/mysql.repo /etc/yum.repos.d/mysql.repo
func_print_head " Installing MySQL "
yum install mysql-community-server -y &>> /tmp/roboshop.log
func_stat_check $?
func_print_head " Starting MySQL Services "
systemctl enable mysqld
systemctl start mysqld
func_stat_check $?
mysql_secure_installation --set-root-pass $mysql_root_password
#mysql -uroot -pRoboShop@1, pass the password from command line

func_print_head " Completed MySQL Setup Successfully "