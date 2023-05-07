app_user=roboshop
print_head(){
   echo -e "\e[32m********* $* ****************\e[0m"
}
schema_setup(){
 if [ "$schema_setup" ==  "mongo" ]; then
    cp ${script_path}/mongo.repo /etc/yum.repos.d/mongo.repo
    yum install mongodb-org-shell -y
    mongo --host mongodb-dev.r1devopsb.online </app/schema/catalogue.js
    printhead "Connected to MongoDB Successfully"
  fi
}

func_nodejs(){
curl -sL https://rpm.nodesource.com/setup_lts.x | bash
yum install nodejs -y
useradd $app_user
mkdir /app
curl -o /tmp/${component}.zip https://roboshop-artifacts.s3.amazonaws.com/user.zip
cd /app
unzip /tmp/${component}.zip
cd /app
npm install
print_head "Installed Dependencies"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
systemctl daemon-reload
systemctl enable cart
systemctl restart ${component}

print_head "service started"

schema_setup

}