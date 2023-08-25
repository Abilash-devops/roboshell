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
yum module disable mysql -y &>>$LOGFILE
validate $? "Disable repo"
cp -rp /home/centos/roboshell/mysql.repo /etc/yum.repos.d/mysql.repo &>>$LOGFILE
validate $? "Copy repo"
yum install mysql-community-server -y &>>$LOGFILE
validate $? "Install mysql community server"
systemctl enable mysqld &>>$LOGFILE
validate $? "Enable mysql service"
systemctl start mysqld &>>$LOGFILE
validate $? "Start mysql"
mysql_secure_installation --set-root-pass RoboShop@1 &>>$LOGFILE