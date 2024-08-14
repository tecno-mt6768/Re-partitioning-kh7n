#!/bin/bash
echo "  "
echo "     ******************************************"
echo "     |         Repartitioning partitions      |"
echo "     |                 By isus203             |"
echo "     ******************************************"
echo " "
# Функция проверки ошибок
function check_error() {
    if [ $? -ne 0 ]; then
        echo "Error: command failed with exit code $?"
        exit 1
    fi
}

echo "Backup boot"
dd if=/dev/block/by-name/boot of=/tmp/boot.img
check_error
echo "" 

# Пути к устройствам и файлам
device="/dev/block/mmcblk0"
sgdisk="/tmp/sgdisk"
boot="/tmp/boot.img"

# Переразметка
echo "Repartition boot"
$sgdisk $device -d 30 -d 31 -n 30:1003520:1200127 -c 30:boot_a -t 30:0700
check_error
$sgdisk $device -d 43 -d 44 -n 43:1708032:1904639 -c 43:boot_b -t 43:0700
check_error
$sgdisk $device -s

# Прошивание 
echo "Flashing boot"
dd if="$boot" of="/dev/block/by-name/boot_a" status=progress
check_error
dd if="$boot" of="/dev/block/by-name/boot_b" status=progress
check_error
echo "" 
echo "Firmware is complete"
