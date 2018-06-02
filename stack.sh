#!/bin/bash

Stat() {
  if [ $? -eq 0 ]; then 
  	echo -e "SUCCESS"
  else 
	echo -e "FAILED"
  	exit 1
  fi
}

STACK_NAME=$1
FILE_NAME=$2
if [ -z "$STACK_NAME" -o -z "$FILE_NAME" ]; then
	echo -e "Need Stackname and FileName as Input"
	exit 1
fi

### Check if stack exists.
aws cloudformation list-stacks | grep $STACK_NAME &>/dev/null
if [ $? -eq 0 ]; then 
	## Stack Exists... Need to delete it.
	aws cloudformation delete-stack --stack-name $STACK_NAME 
        echo -n -e "Deleting Stack.. "
	aws cloudformation wait stack-delete-complete --stack-name $STACK_NAME &>/dev/null
        Stat $?
fi

### Create the stack
echo -n -e "Creating Stack .. "
aws cloudformation create-stack --stack-name $STACK_NAME --template-body file://$FILE_NAME &>/tmp/cflog
if [ $? -ne 0 ]; then 
	cat /tmp/cflog
	Stat 1
fi

aws cloudformation  wait stack-create-complete --stack-name $STACK_NAME &>/dev/null
Stat $?


