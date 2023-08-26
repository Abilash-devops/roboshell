#!/bin/bash
N=("dev" "qas" "preprod" "prod")
INSTANCE_TYPE=""
ami_id=ami-03265a0778a880afb
sg_id=sg-0cb4841e0108eb3f0
subnet_id=subnet-0b7e209a25659cded
for i in ${N[@]}
do
    if [[ $i == "preprod" || $i == "prod"]]
    then 
    INSTANCE_TYPE=t3.micro
    else
    INSTANCE_TYPE=t2.micro
    fi
    aws ec2 run-instances --image-id $ami_id --instance-type $INSTANCE_TYPE --security-group-ids $sg_id --subnet-id $subnet_id --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$i}]"

echo $i
done

