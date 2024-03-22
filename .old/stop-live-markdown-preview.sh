#!/opt/homebrew/bin/bash

if [ -f /tmp/livepreview_pid.tmp ]; then
    kill $(cat /tmp/livepreview_pid.tmp)
    rm /tmp/livepreview_pid.tmp
    echo "Live preview stopped."
else
    echo "No live preview process found."
fi

