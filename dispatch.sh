script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
yum install golang -y
useradd ${app_user}
rm -rf /app
mkdir /app
print_head " Created the directory /app "
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
cd /app
unzip /tmp/dispatch.zip
go mod init dispatch
go get
go build
cp dispatch.service /etc/systemd/system/dispatch.service
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch
print_head " completed dispatch "
