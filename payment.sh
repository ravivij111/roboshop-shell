script_path=$(dirname $0)
source ${script_path}/common.sh
yum install python36 gcc python3-devel -y
useradd roboshop
mkdir /app
echo -e "\e[32m********* Created the directory /app ****************\e[0m"
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip
cd /app
unzip /tmp/payment.zip
cd /app
pip3.6 install -r requirements.txt
cp /home/centos/roboshop-shell/payment.service /etc/systemd/system/payment.service
systemctl daemon-reload
systemctl enable payment
systemctl restart payment
echo -e "\e[32m********* payment service restarted ****************\e[0m"