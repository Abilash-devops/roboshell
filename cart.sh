#!/bin/bash
D=$(date +%F:%H:%M:%S)
SCRIPT_NAME=$0
LOG_PATH=/home/centos/roboshell/logs
LOGFILE=$LOG_PATH/$0-$D-log
u=$(id -u)
R="\e[31m"
G="\e[32m"
N="\e[0m"
Y="\e[33m"
if [ $u -ne 0 ]
then
echo " Please run the script with root or superuser previliges "
exit 1
fi
validate(){
    if [ $? -ne 0 ]
    then 
        echo -e " $2 is $R FAILURE $N"
        exit 1
    else
        echo -e " $2 is $G SUCCESS $N"
    fi
}
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
validate $? "Setting up NPM Source"
yum install nodejs -y &>>$LOGFILE
validate $? "NodeJs installation"
useradd roboshop &>>$LOGFILE
mkdir /app &>>$LOGFILE
curl -L -o /tmp/cart.zip https://roboshop-artifacts.s3.amazonaws.com/cart.zip &>>$LOGFILE
validate $? "download the artifact"
cd /app  &>>$LOGFILE
validate $? "go to app diretory"
unzip /tmp/cart.zip &>>$LOGFILE
validate $? "unzip the artifact"
npm install &>>$LOGFILE
validate $? "Install the dependencies"
cp -rp /home/centos/roboshell/cart.service /etc/systemd/system/cart.service &>>$LOGFILE
validate $? "copied the service"
systemctl daemon-reload &>>$LOGFILE
validate $? "load the deaomon cart service"
systemctl enable cart &>>$LOGFILE
validate $? "enable the deaomon cart service"
systemctl start cart &>>$LOGFILE
validate $? "start the deaomon cart service"