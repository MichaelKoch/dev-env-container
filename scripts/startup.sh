if [ "${PASSWORD}" = "CHANGE_ME" ]; then
    echo "PASSSWORD="${PASSWORD} 
    echo "PLEASE CHANGE PASSWORD"
    exit 500
fi

echo "SETTING ROOT PASSWORD"
echo 'root:'${PASSWORD} | chpasswd
echo STARTUP DEVELOPMENT CONATINER 
/usr/sbin/sshd -D&
(cd /workspace && /bin/bash )

