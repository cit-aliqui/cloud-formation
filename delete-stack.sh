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
if [ -z "$STACK_NAME" ]; then
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

