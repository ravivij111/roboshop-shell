script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbit_mq_password=$1

if [ -z "$rabbit_mq_password" ]
then
  echo Imput Roboshop Appuser password is missing
  exit
fi

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
yum install erlang -y
func_print_head " installed erlang  "
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> /tmp/roboshop.log
func_stat_check $?
func_print_head " Install RabbitMQ "
yum install rabbitmq-server -y &>> /tmp/roboshop.log
func_stat_check $?
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server &>> /tmp/roboshop.log
func_stat_check $?
func_print_head " RabbitMQ Started and confirm by systemctl status rabbitmq-server "
rabbitmqctl add_user roboshop ${rabbit_mq_password}
#roboshop123
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> /tmp/roboshop.log
func_stat_check $?
func_print_head " Completed MQ SetUp  "