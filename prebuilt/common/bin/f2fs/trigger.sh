#!/sbin/sh

if [ -e /tmp/anykernel/f2fs.sh ]
then
    mount | grep -q '/system type f2fs'
    F2FS=$?
    if [ $F2FS -eq 0 ]
    then
        chmod 777 /tmp/anykernel/f2fs.sh
        /tmp/anykernel/f2fs.sh
    fi
fi
