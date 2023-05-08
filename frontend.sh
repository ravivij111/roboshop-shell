script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

#echo   $app_user

yum install nginx -y

rm -rf /usr/share/nginx/html/*
print_head " Removed the Files /usr/share/nginx/html/* "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip
cd /usr/share/nginx/html
unzip /tmp/frontend.zip


cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf
print_head " Removed the Files /usr/share/nginx/html/* **************** "
systemctl enable nginx
systemctl restart nginx

print_head "  nginx started successfully  "