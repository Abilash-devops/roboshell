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
yum install golang -y &>>$LOGFILE
validate $? "install golang"
useradd roboshop &>>$LOGFILE
mkdir /app &>>$LOGFILE
curl -L -o /tmp/dispatch.zip https://roboshop-artifacts.s3.amazonaws.com/dispatch.zip &>>$LOGFILE
validate $? "downlaod the patch"
cd /app &>>$LOGFILE
validate $? "move to app"
unzip /tmp/dispatch.zip &>>$LOGFILE
validate $? "unzip code "
go mod init dispatch &>>$LOGFILE
go get &>>$LOGFILE
go build &>>$LOGFILE
validate $? "install dependencies"
cp -rp /home/centos/roboshell/dispatch.service /etc/systemd/system/dispatch.service &>>$LOGFILE
validate $? "copy servicefile"
systemctl daemon-reload &>>$LOGFILE
validate $? "load servicefile"
systemctl enable dispatch &>>$LOGFILE
validate $? "enable servicefile"
systemctl start dispatch &>>$LOGFILE
validate $? "start servicefile"
