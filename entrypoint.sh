if [ "${PASSWORD}" = "CHANGE_ME" ]; then
    echo "PASSWORD="${PASSWORD} 
    echo "PLEASE CHANGE PASSWORD"
    exit 500
fi
useradd -m ${USERNAME} -s /bin/bash
chown ${USERNAME} /home/${USERNAME} -R
echo ${PASSWORD}
echo "SETTING ROOT PASSWORD"
echo 'root:'${PASSWORD} | chpasswd
echo ${USERNAME}':'${PASSWORD} | chpasswd
echo STARTUP DEVELOPMENT CONTAINER 
tail -f /dev/null
