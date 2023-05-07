script_path=$(dirname $0)
source ${script_path}/common.sh
yum install maven -y
useradd ${app_user}
mkdir /app
curl -L -o /tmp/shipping.zip https://roboshop-artifacts.s3.amazonaws.com/shipping.zip
cd /app
unzip /tmp/shipping.zip

mvn clean package
mv target/shipping-1.0.jar shipping.jar
cp ${script_path}/shipping.service /etc/systemd/system/shipping.service

echo -e "\e[33m********* shipping service enabled erlang   ****************\e[0m"
yum install mysql -y
mysql -h mysql-dev.r1devopsb.online -uroot -pRoboShop@1 < /app/schema/shipping.sql
systemctl restart shipping

echo -e "\e[33m********* Installed MySQL in Shipping   ****************\e[0m"

systemctl enable shipping
systemctl restart shipping

echo -e "\e[33m********* Restarted the services   ****************\e[0m"