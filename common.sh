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
func_print_head "Installing Maven"
  yum install maven -y &>> $log_file
  func_stat_check $?
  func_app_prereq
  mvn clean package  &>> $log_file
  mv target/${component}-1.0.jar ${component}.jar
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
  func_print_head "Downloading the ${component}  zip"
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip &>> /tmp/roboshop.log
  func_stat_check $?
  cd /app
   func_print_head "unzipping the ${component} files"
  unzip /tmp/${component}.zip &>> /tmp/roboshop.log
  func_stat_check $?

}

func_print_head(){
   echo -e "\e[32m********* $* ****************\e[0m"
}
func_schema_setup(){
  func_print_head " Schema set up started "
 if [ "$schema_setup" ==  "mongo" ]; then
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    yum install mongodb-org-shell -y &>> $log_file
    func_stat_check $?
    mongo --host mongodb-dev.r1devopsb.online </app/schema/${component}.js
    func_print_head "Connected to MongoDB Successfully"
  elif [ "$schema_setup" ==  "mysql" ]; then
    yum install mysql -y
    mysql -h mysql-dev.r1devopsb.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
    #RoboShop@1
    func_print_head " Installed MySQL in ${component}  "
  fi
}

func_nodejs(){

  func_print_head "Installing Node JS"
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash  &>> $log_file
  func_print_head " Downloaded the setup"
  yum install nodejs -y &>> $log_file
  func_stat_check $?
  func_app_prereq
  cd /app
  rm /tmp/${component}.zip
  unzip /tmp/${component}.zip &>> $log_file
  cd /app
   func_print_head "Installing the dependencies JS"
  npm install &>> $log_file
  func_stat_check $?
  func_systemd_setup
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
  func_stat_check $?

  func_app_prereq

  func_print_head " Installing Python Dependencies"
   pip3.6 install -r requirements.txt &>> $log_file
   func_stat_check $?
  func_print_head " Update Password in System Service file Python Dependencies"
  sed -i -e "s|rabbitmq_appuser_password|${rabbitmq_appuser_password}|" ${script_path}/${component}.service &>> $log_file
   func_stat_check $?
  func_systemd_setup
}

func_app_golang(){

  func_print_head " Installing golang "
  yum install golang -y &>> /tmp/roboconf.log
  func_stat_check $?

  func_app_prereq

  func_print_head " Init, get & build "
  go mod init dispatch
  go get
  go build
  func_stat_check $?

  func_systemd_setup
}