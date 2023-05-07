script_path=$(dirname $0)
source ${script_path}/common.sh

curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd roboshop
rm -rf /app
echo -e "\e[32m********* Removal /app Directory Completed ****************\e[0m"
mkdir /app
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip
cd /app
unzip /tmp/catalogue.zip
cd /app
npm install
echo -e "\e[32m********* Installation of Node JS is completed ****************\e[0m"
cp /home/centos/roboshop-shell/catalogue.service /etc/systemd/system/catalogue.service
systemctl daemon-reload
systemctl enable catalogue
systemctl restart catalogue
echo -e "\e[32m********* Catalogue Service Restarted Successfully ****************\e[0m"
cp /home/centos/roboshop-shell/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.r1devopsb.online </app/schema/catalogue.js
echo -e "\e[32m********* Connected to MongoDB Successfully ****************\e[0m"
