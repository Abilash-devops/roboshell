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
curl -o /tmp/catalogue.zip https://roboshop-artifacts.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
validate $? "download the artifact"
cd /app  &>>$LOGFILE
validate $? "Moving to app dir"
unzip /tmp/catalogue.zip &>>$LOGFILE
validate $? "unzip catalogue"
npm install  &>>$LOGFILE
validate $? "Checking npm dependencies"
cp -rp /home/centos/roboshell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
validate $? "Copy the catalogue service"
systemctl daemon-reload &>>$LOGFILE
validate $? "load the deaomon catalogue service"
systemctl enable catalogue &>>$LOGFILE
validate $? "enable the deaomon catalogue service"
systemctl start catalogue &>>$LOGFILE
validate $? "start the deaomon catalogue service"
cp -rp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
validate $? "copy the repo for client"
yum install mongodb-org-shell -y &>>$LOGFILE
validate $? "Installation of mongo client"
mongo --host mongo.padmasrikanth.tech </app/schema/catalogue.js &>>$LOGFILE
validate $? "load the data to the mongodb"


