script=$(realpath "$0")
script_path=$(dirname "$script")
source ${script_path}/common.sh
schema_setup=mongo
component=catalogue
func_nodejs
