script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

component=catalogue
func_nodejs
cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org-shell -y
mongo --host mongodb-dev.r1devopsb.online </app/schema/catalogue.js
echo -e "\e[32m********* Connected to MongoDB Successfully ****************\e[0m"
