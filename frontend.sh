script_path=$(dirname $0)
echo " dirname  is :"  $script_path
source ${script_path}/common.sh
exit
yum install nginx -y

rm -rf /usr/share/nginx/html/*
echo -e "\e[32m********* Removed the Files /usr/share/nginx/html/* ****************\e[0m"
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip


cp /home/centos/roboshop-shell/roboshop.conf /etc/nginx/default.d/roboshop.conf
echo -e "\e[32m********* Removed the Files /usr/share/nginx/html/* ****************\e[0m"
systemctl enable nginx
systemctl restart nginx

echo -e "\e[32m********* nginx started successfully ****************\e[0m"