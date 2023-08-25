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
curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE
validate $? "YUM Repos from the script provided by vendor"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE
validate $? "YUM Repos for RabbitMQ."
yum install rabbitmq-server -y &>>$LOGFILE
validate $? "Install RabbitMQ"
systemctl enable rabbitmq-server &>>$LOGFILE 
validate $? "enable RabbitMQ"
systemctl start rabbitmq-server &>>$LOGFILE 
validate $? "start RabbitMQ"
rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE
validate $? "add user and password RabbitMQ"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE
validate $? "set permissions RabbitMQ"