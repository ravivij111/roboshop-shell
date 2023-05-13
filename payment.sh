script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
component=payment

mysql_root_password=$1

if [ -z "$mysql_root_password" ]
then
  echo Input mySQL password is missing
  exit 1
fi
func_python










