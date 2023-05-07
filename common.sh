app_user=roboshop

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
echo -e "\e[32m********* Installed Dependencies  ****************\e[0m"
cp ${script_path}/${component}.service /etc/systemd/system/${component}.service
systemctl daemon-reload
systemctl enable cart
systemctl restart ${component}

echo -e "\e[32m*********  service started  ****************\e[0m"

}