ip -4 addr show | grep "inet" | awk '{print $2}' | cut -d/ -f 1
