#!/bin/sh
NAME=$1

runInstance()
{    
  CONTAINER_NAME=dev-env-$NAME
  echo "building image 'dev-env:latest' ..."
  docker build -t dev-env . 
  echo "removing instance $CONTAINER_NAME"
  docker container rm $CONTAINER_NAME -f
  echo "starting instance $CONTAINER_NAME"
 echo  docker run \
  -h $CONTAINER_NAME.my.devpods  \
  -v /home/${USER}/git:/home/ubuntu/git \
  -u $(id -u ${USER}):$(id -g ${USER}) \
  --name $CONTAINER_NAME \
  --restart always \
  -d dev-env 
}
runInstance
echo "SHARED HOME:" $SHARE