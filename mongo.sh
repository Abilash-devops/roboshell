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

cp -rp /home/centos/roboshell/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$LOGFILE
yum install mongodb-org -y &>>$LOGFILE
validate $? "Installed mongodb"
systemctl enable mongod &>>$LOGFILE
validate $? "Enabled mongodb"
systemctl start mongod &>>$LOGFILE
validate $? "validated mongodb"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$LOGFILE
validate $? "Edited  mongodb config file" 
systemctl restart mongod &>>$LOGFILE
validate $? "restarted mongodb again " 
