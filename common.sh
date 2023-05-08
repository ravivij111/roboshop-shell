app_user=roboshop

func_java(){

  yum install maven -y
  useradd ${app_user}
  mkdir /app
  curl -L -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
  cd /app
  unzip /tmp/${component}.zip

  mvn clean package
  mv target/${component}-1.0.jar ${component}.jar
  cp ${script_path}/${component}.service /etc/systemd/system/${component}.service


  printhead " ${component} service enabled erlang "
  yum install mysql -y
  mysql -h mysql-dev.r1devopsb.online -uroot -p${mysql_root_password} < /app/schema/${component}.sql
  #RoboShop@1

  printhead " Installed MySQL in ${component}  "


  systemctl daemon-reload
  systemctl enable ${component}
  systemctl restart ${component}

  printhead " Restarted the ${component} services "

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
  fi
}

func_nodejs(){
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd $app_user
rm -rf /app
mkdir /app
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/${component}.zip
cd /app
unzip /tmp/${component}.zip
cd /app
npm install
func_print_head "Installed Dependencies"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
systemctl daemon-reload
systemctl enable cart
systemctl restart ${component}

func_print_head ${component}" service started"

func_schema_setup

}