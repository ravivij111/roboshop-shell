script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

#echo   $app_user
func_print_head " Installing Nginx"
yum install nginx -y &>> /tmp/roboshop.log
func_stat_check $?

rm -rf /usr/share/nginx/html/*
func_print_head " Downloading and unzipping the front end zip files "
curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>> /tmp/roboshop.log
cd /usr/share/nginx/html
unzip /tmp/frontend.zip &>> /tmp/roboshop.log
func_stat_check $?

cp ${script_path}/roboshop.conf /etc/nginx/default.d/roboshop.conf
func_print_head " starting the nginx services **************** "
systemctl enable nginx
systemctl restart nginx
func_stat_check $?
