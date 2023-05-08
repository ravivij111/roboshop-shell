script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo Input mySQL password is missing
  exit
fi

yum install maven -y
useradd ${app_user}
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

mvn clean package
mv target/shipping-1.0.jar shipping.jar
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service
systemctl daemon-reload
systemctl enable shipping
systemctl restart shipping

printhead " shipping service enabled erlang "
yum install mysql -y
mysql -h mysql-dev.r1devopsb.online -uroot -p${mysql_root_password} < /app/schema/shipping.sql
#RoboShop@1

printhead " Installed MySQL in Shipping  "


systemctl restart shipping

printhead " Restarted the services "