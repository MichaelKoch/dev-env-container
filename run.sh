#!/bin/sh
NAME=$1
PASSWORD=$2
SSH_PORT=$3
SHARE_BASE=~/share
SHARE=$SHARE_BASE/$NAME
mkdir -p $SHARE
runInstance()
{    
  CONTAINER_NAME=dev-env-$NAME-$SSH_PORT
  echo "building image 'dev-env:latest' ..."
  docker build -t dev-env . 
  echo "removing instance $CONTAINER_NAME"
  docker container rm $CONTAINER_NAME -f
  echo "starting instance $CONTAINER_NAME"
  docker run \
  -h $CONTAINER_NAME.my.devpods  \
  -e USERNAME=$NAME \
  -e PASSWORD=$PASSWORD \
  -e SSH_PORT=$SSH_PORT \
  -p $SSH_PORT:22 \
  -v $SHARE:/home/$NAME \
  --name $CONTAINER_NAME \
  --restart always \
  -d dev-env 
}
runInstance
echo "PORT :$SSH_PORT"
echo "SHARED HOME:" $SHARE