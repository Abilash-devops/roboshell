#!/bin/bash
a=("dev" "qas" "preprod" "prod")
image_id=ami-03265a0778a880afb
INSTANCE_TYPE=""
sg_id=sg-0cb4841e0108eb3f0
subnet_id=subnet-0b7e209a25659cded
for i in ${a[@]}
do
    if [[ $i == "preprod" || $i == "prod" ]]
    then
        INSTANCE_TYPE=t3.micro
    else
        INSTANCE_TYPE=t2.micro
    fi
    echo "Creating $i instance"
    b=$(aws ec2 run-instances --image-id $image_id --instance-type $INSTANCE_TYPE --security-group-ids $sg_id --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]" | jq -r '.Instances[0].PrivateIpAddress')
    echo " For $i instance private IP adress is :$b"
done

