script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd $app_user
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install
echo -e "\e[32m********* Installed Dependencies  ****************\e[0m"
cp ${script_path}/cart.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

echo -e "\e[32m********* cart service started  ****************\e[0m"