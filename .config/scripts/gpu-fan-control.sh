
#!/bin/bash

# Start virtual X server if not running
DISPLAY_NUM=99
XVFB_DISPLAY=":$DISPLAY_NUM"

# Check if Xvfb is running on our display
if ! pgrep -f "Xvfb $XVFB_DISPLAY" > /dev/null; then
    echo "Starting virtual X server..."
    Xvfb $XVFB_DISPLAY -screen 0 1024x768x24 2>/dev/null &
    XVFB_PID=$!
    sleep 2

    # Check if Xvfb started successfully
    if ! kill -0 $XVFB_PID 2>/dev/null; then
        echo "Failed to start Xvfb"
        exit 1
    fi
fi

# Set display for nvidia-settings
export DISPLAY=$XVFB_DISPLAY

# Set fan control and speeds
echo "Setting GPU fan control..."
sudo nvidia-settings -a "[gpu:0]/GPUFanControlState=1" 2>/dev/null
sudo nvidia-settings -a "[fan:0]/GPUTargetFanSpeed=62" 2>/dev/null
sudo nvidia-settings -a "[fan:1]/GPUTargetFanSpeed=62" 2>/dev/null

echo "GPU fan control configured successfully"
