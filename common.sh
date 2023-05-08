app_user=roboshop

func_java(){

  yum install maven -y

  func_app_prereq
  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar
  printhead " ${component} service enabled erlang "
  func_systemd_setup
}

func_app_prereq(){
  useradd ${app_user}
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
  curl -sL https://rpm.nodesource.com/setup_lts.x | bash
  yum install nodejs -y
  func_app_prereq
  cd /app
  unzip /tmp/${component}.zip
  cd /app
  npm install
  func_print_head "Installed Dependencies"
  func_systemd_setup
  func_schema_setup
}

func_systemd_setup(){
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
  systemctl daemon-reload
  systemctl enable cart
  systemctl restart ${component}
  func_print_head ${component}" service started"
}