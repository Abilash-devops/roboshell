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
yum install python36 gcc python3-devel -y &>>$LOGFILE
valdite $? "Install python"
useradd roboshop &>>$LOGFILE
mkdir /app &>>$LOGFILE
curl -L -o /tmp/payment.zip https://roboshop-artifacts.s3.amazonaws.com/payment.zip &>>$LOGFILE
valdite $? "Download code"
cd /app &>>$LOGFILE
valdite $? "switch to app dir"
unzip /tmp/payment.zip &>>$LOGFILE
valdite $? "extract code"
pip3.6 install -r requirements.txt &>>$LOGFILE
valdite $? "run dependencies"
cp -rp /home/centos/roboshell/payment.service /etc/systemd/system/payment.service &>>$LOGFILE
valdite $? "update the service file"
systemctl daemon-reload &>>$LOGFILE
valdite $? "reload the service file"
systemctl enable payment &>>$LOGFILE
valdite $? "enable the service file"
systemctl start payment &>>$LOGFILE
valdite $? "start the service file"
