script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
rabbitmq_appuser_password=$1

if [ -z "$mysql_root_password" ]
then
  echo Input mySQL password is missing
  exit
fi
func_python










