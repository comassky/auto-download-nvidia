#!/bin/bash

LATEST=$(curl --silent http://download.nvidia.com/XFree86/Linux-x86_64/latest.txt)
IFS=' ' read -r -a array <<< "$LATEST"
NAME=$(cut -d'/' -f2 <<<"${array[1]}")
INSTALLED_DRIVER=$(nvidia-smi --query-gpu=driver_version --format=csv,noheader)
echo ""
echo "********************************************"
echo " Latest Nvidia driver : ${array[0]}"
echo " Local driver         : $INSTALLED_DRIVER"
if [ "${array[0]}" = "$INSTALLED_DRIVER" ]
then
 echo ""
 echo " No update available"
 echo ""
fi
echo "********************************************"
echo ""

if [ "${array[0]}" != "$INSTALLED_DRIVER" ] || [ "$1" = "1" ]
then
 read -p "Do you wish to update Nvidia driver ($INSTALLED_DRIVER => ${array[0]}) ? Y/n : " yn
  case $yn in
        [Nn]* ) exit;;
            * ) wget  --no-check-certificate -P /root/nvidiaDrivers "https://international.download.nvidia.com/XFree86/Linux-x86_64/${array[1]}"; chmod +x "/root/nvidiaDrivers/$NAME";;
  esac
fi

