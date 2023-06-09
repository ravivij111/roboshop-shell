script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbit_mq_password=$1

if [ -z "$rabbit_mq_password" ]
then
  echo Imput Roboshop Appuser password is missing
  exit 1
fi
func_print_head " installing Erlang and Rabbit MQ  "
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash
yum install erlang -y
func_print_head $?

curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash  &>> /tmp/roboshop.log
yum install rabbitmq-server -y &>> /tmp/roboshop.log
func_stat_check $?
func_print_head " Starting RabbitMQ service "
systemctl enable rabbitmq-server
systemctl restart rabbitmq-server &>> /tmp/roboshop.log
func_stat_check $?
#func_print_head "  RabbitMQ Service Status check  "
#systemctl status rabbitmq-server
#func_print_head " Completed RabbitMQ Service Status check  "
    func_print_head " Add roboshop user "
    rabbitmqctl add_user roboshop ${rabbit_mq_password} &>> /tmp/roboshop.log
    #roboshop123
func_print_head " Set the permissions to user  "
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> /tmp/roboshop.log
func_stat_check $?

func_print_head " Checking RabbitMQ service status "
systemctl status rabbitmq-server

func_print_head " Completed MQ SetUp  "