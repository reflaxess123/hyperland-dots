
#!/bin/bash
xhost +SI:localuser:root &>/dev/null
sudo nvidia-settings -a "[gpu:0]/GPUFanControlState=1" &>/dev/null
sudo nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=62" &>/dev/null
sudo nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=62" &>/dev/null
