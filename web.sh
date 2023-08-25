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
yum install nginx -y &>>$LOGFILE
validate $? "Install nginx"
systemctl enable nginx &>>$LOGFILE
validate $? "enable nginx"
systemctl start nginx &>>$LOGFILE
validate $? "start nginx"
rm -rf /usr/share/nginx/html/* &>>$LOGFILE
validate $? "delet nginx html"
curl -o /tmp/web.zip https://roboshop-artifacts.s3.amazonaws.com/frontend.zip &>>$LOGFILE
validate $? "download the file"
cd /usr/share/nginx/html &>>$LOGFILE
validate $? "switvch to nginx html"
unzip /tmp/web.zip &>>$LOGFILE
validate $? "unzip code"
cp -rp /home/centos/roboshell/robo.conf /etc/nginx/default.d/robo.conf &>>$LOGFILE
validate $? "copy proxy"
systemctl restart nginx &>>$LOGFILE
validate $? "restart nginx"
