script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
func_print_head " Installing golang "
yum install golang -y &>> /tmp/roboconf.log
func_stat_check $?
useradd ${app_user}
rm -rf /app
func_print_head " Creating the directory "
mkdir /app
func_stat_check $?

rm -rf /tmp/dispatch.zip

func_print_head " download the dispatch Zip files "
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip
func_stat_check $?
cd /app

func_print_head " unzip dispatch Zip files "
unzip /tmp/dispatch.zip
func_stat_check $?

func_print_head " Init, get & build "
go mod init dispatch
go get
go build
func_stat_check $?
cp dispatch.service /etc/systemd/system/dispatch.service


func_print_head " Dispatch server is starting "
systemctl daemon-reload
systemctl enable dispatch
systemctl restart dispatch
func_stat_check $?
func_print_head " completed dispatch "
