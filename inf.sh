#!/bin/bash

interfaces=$(ls -1 /sys/class/net/ | grep -v lo)
hostname=$(hostname -f)
uptime=$(w | head -1 | tr -d "," | cut -d " " -f3,4,5,6)
la=$(w | head -1 | cut -d " " -f11,12,13,14,15)
other_la=$(w | egrep -o "load average: ([0-9]+\,[0-9]{2}), ([0-9]+\,[0-9]{2}), ([0-9]+\,[0-9]{2})")
mem_total=$(cat /proc/meminfo | grep MemTotal)
mem_free=$(cat /proc/meminfo | grep MemFree)
mem_act=$(cat /proc/meminfo | grep Active:)
mem_inact=$(cat /proc/meminfo | grep Inactive:)
swap_total=$(cat /proc/meminfo | grep SwapTotal)
swap_free=$(cat /proc/meminfo | grep SwapFree)
disk_df=$(df -x devtmpfs -x tmpfs | grep "\/")

echo "Hostname: $hostname"
echo "Uptime: $uptime"
echo $la
echo
echo "Network:"
for int in $interfaces; do
    ip=$(ip a s $int | grep inet | grep global | awk '{print $2}')
    nm=$(ipcalc -m $ip | cut -d "=" -f2)
    echo "- $int: IP Address/Prefix - $ip, Netmask - $nm"
done
echo
echo "Memory:"
echo "- $mem_total"
echo "- $mem_free"
echo "- $mem_act"
echo "- $mem_inact"
echo "- $swap_total"
echo "- $swap_free"
echo
echo "Disks:"
echo $disk_df | while read line; do echo - $line; done
