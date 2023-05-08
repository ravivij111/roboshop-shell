script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$mysql_root_password" ]
then
  echo Input mySQL password is missing
  exit
fi

yum install python36 gcc python3-devel -y
useradd ${app_user}
mkdir /app
print_head " Created the directory /app "
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
pip3.6 install -r requirements.txt
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}}" ${script_path}/payment.service
cp ${script_path}/payment.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
print_head " payment service restarted "