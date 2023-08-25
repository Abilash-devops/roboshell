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
yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE
validate $? "Installed repo"
yum module enable redis:remi-6.2 -y &>>$LOGFILE
validate $? "enable repo6.2"
yum install redis -y &>>$LOGFILE
validate $? "Install Redis"
sed -i 's/127.0.0.1/0.0.0.0/g' /etc/redis.conf /etc/redis/redis.conf
systemctl enable redis &>>$LOGFILE
validate $? "Enable redis"
systemctl start redis
validate $? "start redis"
