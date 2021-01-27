#! /bin/bash
# ref github.com/the-codepunker/ubuntu-nvidia-mining
	#lspci -v | grep VGA
	#
	#sudo update-grub
	#sudo add-apt-repository ppa:graphics-drivers/ppa
	#sudo apt update
	#sudo apt-get upgrade
	#shutdown -r now
	#sudo apt-get install nvidia-current nvidia-current-updates
	#sudo apt-get purge nvidia-* (when needed)
	#
	#sudo prime-select nvidia
	#sudo apt-get install nvidia-375
	#nvidia-xconfig --enable-all-gpus
	#cat /etc/X11/xorg.conf
	#sudo mv /etc/X11/xorg.conf /etc/X11/xorg_bak_daniel.conf
	#sudo nvidia-xconfig -a --cool-bits=31 --allow-empty-initial-configuration
	#sudo sed -i '/Option         "AllowEmptyInitialConfiguration" "True"/a    Option         "ConnectedMonitor" "DFP-0"' /etc/X11/xorg.conf
	#sudo sed -i '/Option         "ConnectedMonitor" "DFP-0"/a    Option         "CustomEDID" "DFP-0:/etc/X11/dfp0.edid"' /etc/X11/xorg.conf
	#sudo cp dfp0.edid /etc/X11/dfp0.edid
	#sudo chattr +i /etc/X11/xorg.conf
	#sudo DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0 nvidia-settings -t -q GPUUtilization
	#sudo shutdown -r now

	export DISPLAY=:0

    read -d "\0" -a number_of_gpus < <(nvidia-smi --query-gpu=count --format=csv,noheader,nounits)
    printf "%s\n" "found ${number_of_gpus[0]} gpu[s]..."
    index=$(( number_of_gpus[0] - 1 ))
    for i in $(seq 0 $index)
    do
       if nvidia-smi -i $i --query-gpu=name --format=csv,noheader,nounits | grep -E "1060" 1> /dev/null
       then
           printf "%s\n" "found GeForce GTX 1080 at index $i..."
           printf "%s\n" "setting persistence mode..."
           nvidia-smi -i $i -pm 1
           printf "%s\n" "setting power limit to 75 watts.."
           nvidia-smi -i $i -pl 75
           printf "%s\n" "setting memory overclock of 500 Mhz..."
           nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[3]=500
	   #DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0 nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[2]=500          
       elif nvidia-smi -i $i --query-gpu=name --format=csv,noheader,nounits | grep -E "1080" 1> /dev/null
       then 
           printf "%s\n" "found GeForce GTX 1080 at index $i..."
           printf "%s\n" "setting persistence mode..."
           sudo nvidia-smi -i $i -pm 1
           printf "%s\n" "setting power limit..."
           sudo nvidia-smi -i $i -pl 175
           printf "%s\n" "setting memory overclock..."
	   #DISPLAY=:0 XAUTHORITY=/var/run/lightdm/root/:0 
	   #nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[2]=550
	   sudo DISPLAY=:0 XAUTHORITY=/run/user/125/gdm/Xauthority nvidia-settings -a [gpu:${i}]/GPUFanControlState=1
	   sudo DISPLAY=:0 XAUTHORITY=/run/user/125/gdm/Xauthority nvidia-settings -a [fan:${i}]/GPUTargetFanSpeed=50
           sudo DISPLAY=:0 XAUTHORITY=/run/user/125/gdm/Xauthority nvidia-settings -a [gpu:${i}]/GPUGraphicsClockOffset[3]=0
	   sudo DISPLAY=:0 XAUTHORITY=/run/user/125/gdm/Xauthority nvidia-settings -a [gpu:${i}]/GPUMemoryTransferRateOffset[3]=0
	   #nvidia-settings -a [gpu:${i}]/GPUGraphicsMemoryOffset[3]=100
       fi 
    done
