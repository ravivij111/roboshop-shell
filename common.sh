app_user=roboshop
script=$(realpath "$0")
scipt_path=$(dirname "$script")
log_file=/tmp/roboshop.log
func_stat_check(){
  if [ $1 -eq 0 ] ; then
    echo -e "\e[32mSUCESS\e[0m"
  else
    echo -e "\e[31mFailure\e[0m"
    echo "refer the log file /tmp/roboshop.log"
    exit 1
  fi
}

func_java(){

  yum install maven -y &>> $log_file
  func_stat_check $?
  func_app_prereq
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar
  printhead " ${component} service enabled erlang "
  func_systemd_setup
}

func_app_prereq(){
  id ${app_user} &>> /tmp/roboshop.log
  #id gives 0 if user is there else it gives 1
  if [ $? -ne 0 ]; then
    useradd ${app_user} &>> /tmp/roboshop.log
  fi

  rm -rf /app
  mkdir /app
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

}

func_print_head(){
   echo -e "\e[32m********* $* ****************\e[0m"
}
func_schema_setup(){
 if [ "$schema_setup" ==  "mongo" ]; then
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    yum install mongodb-org-shell -y
    func_stat_check $?
    mongo --host mongodb-dev.r1devopsb.online </app/schema/${component}.js
    printhead "Connected to MongoDB Successfully"
  elif [ "$schema_setup" ==  "mysql" ]; then
    yum install mysql -y
    mysql -h mysql-dev.r1devopsb.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
    #RoboShop@1
    printhead " Installed MySQL in ${component}  "
  fi
}

func_nodejs(){

  func_print_head "Installing Node JS"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  yum install nodejs -y &>> $log_file
  func_stat_check $?
  func_app_prereq
  cd /app
  unzip /tmp/${component}.zip
  cd /app
   func_print_head "Installing the dependencies JS"
  npm install &>> $log_file
  func_stat_check $?

  func_systemd_setup
  func_schema_setup
}

func_systemd_setup(){
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component} &>> $log_file
  systemctl status ${component}
  func_print_head ${component}" service started"
}

func_python(){
func_print_head " Installing Python "
yum install python36 gcc python3-devel -y &>> $log_file
func_app_prereq
func_print_head " Installing Python Dependencies"
pip3.6 install -r requirements.txt &>> $log_file
func_print_head " Update Password in System Service file Python Dependencies"
sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}}" ${script_path}/${component}.service &>> $log_file
func_stat_check $?
func_systemd_setup
}