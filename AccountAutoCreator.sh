#!/bin/sh
# auto create account and send passwd via email


if [ `whoami` != "root" ];then
    echo -e "\nPlease run as root ...\n"
    exit 0
fi

#USERLIST="user1 user2"
USERLIST=`cat user_list`
ID_PREFIX=s
USER_EMAIL_HOST="mail.hostname"
COURSE="course name"
ADMIN_BCC="admin@hostname"
ADMIN_MAIL_SENDER="admin@hostname"
HOME="/home/student/"
HOME_PERMISSION=751
SHELL="/bin/tcsh"
SERVER_HOSTNAME="server.hostname"
SERVER_PORT="22"

mkdir -p $HOME

for user in $USERLIST
do
    PASS=`pw useradd $ID_PREFIX$user -d $HOME$ID_PREFIX$user/ -m -M $HOME_PERMISSION -s $SHELL -w random | cut -d ' ' -f 5`
    echo "
User account for $COURSE:

Your account is $ID_PREFIX$user, and the password is $PASS

Please use a secure shell(ssh) client such as putty(http://the.earth.li/~sgtatham/putty/latest/x86/putty.exe) to login.

If you want to trasfer files from/to this server, please use sftp protocol, because ftp is not safe, so we don't support it, you can use tools like filezilla to do it!
(http://forum.cse.yzu.edu.tw/course/FileZilla_3.9.0.5_win32-setup.exe)

Server info:
Hostname - $SERVER_HOSTNAME
Port          - $SERVER_PORT

Please use command : 'passwd' to change your password if you want.

Your comments and suggestions are welcome!

Regards,
Admin." | mail -s "User account for $COURSE" -b $ADMIN_BCC $ID_PREFIX$user@$USER_EMAIL_HOST -f $ADMIN_MAIL_SENDER
    #echo -e "$ID_PREFIX$user \t $PASS" >> backup_password_list
done

