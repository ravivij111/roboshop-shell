curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
mkdir /app
curl -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/cart.zip
cd /app
npm install
echo -e "\e[32m********* Installed Dependencies  ****************\e[0m"
cp /home/centos/roboshop-shell/cart.service /etc/systemd/system/cart.service
systemctl daemon-reload
systemctl enable cart
systemctl restart cart

echo -e "\e[32m********* cart service started  ****************\e[0m"