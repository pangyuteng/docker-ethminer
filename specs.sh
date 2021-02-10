echo motherboard -------------
dmidecode -t 2
echo cpu----------------
cat /proc/cpuinfo  | grep 'name'| uniq
echo ram ---------------
dmidecode --type 17
