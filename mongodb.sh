script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh

cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
yum install mongodb-org -y

#Update listen address from 127.0.0.1 to 0.0.0.0 in /etc/mongod.conf
sed -i -e 's|127.0.0.1|0.0.0.0|' /etc/mongod.conf
systemctl enable mongod
systemctl restart mongod

print_head "  Completed MongoDB SetUp "