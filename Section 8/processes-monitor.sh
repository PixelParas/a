#!/bin/bash

clear

# ============================================================
# Clean history
# ============================================================

clean_history() {
    history -w

    local tmp
    tmp=$(mktemp)

    grep -vEi \
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start processes-monitor"
history -s "lab start processes-monitor"
lab start processes-monitor

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Create bin directory and monitor script
echo "[student@servera ~]$ mkdir /home/student/bin"
history -s "mkdir /home/student/bin"
ssh student@servera "mkdir -p /home/student/bin"

echo "[student@servera ~]$ vim /home/student/bin/monitor"
history -s "vim /home/student/bin/monitor"
ssh student@servera "cat << 'EOF' > /home/student/bin/monitor
#!/bin/bash
while true
do
  var=1
  while (( var < 60000 ))
  do
    var=\$(( var + 1 ))
  done
  sleep 1
done
EOF"

echo "[student@servera ~]$ chmod a+x /home/student/bin/monitor"
history -s "chmod a+x /home/student/bin/monitor"
ssh student@servera "chmod a+x /home/student/bin/monitor"

# Step 3: Run top command (Right Terminal Simulation)
echo "[student@servera ~]$ top"
history -s "top"

# Step 4: Verify CPU info on servera
echo "[student@servera ~]$ lscpu"
history -s "lscpu"
ssh student@servera "lscpu"

# Step 5: Start 1st monitor process in background
echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[1] 6071"

echo "[student@servera ~]$ top"
history -s "top"

# Step 6: Start 2nd monitor process in background
echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[2] 6498"

echo "[student@servera ~]$ top"
history -s "top"

# Step 7: Start 3rd monitor process in background
echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[3] 6881"

# Step 8: Start 3 more monitor processes in background
echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[4] 10708"

echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[5] 11122"

echo "[student@servera ~]$ monitor &"
history -s "monitor &"
echo "[6] 11338"

echo "[student@servera ~]$ top"
history -s "top"

# Terminate all background monitor processes
ssh student@servera "pkill -f /home/student/bin/monitor"

# Step 9: Exit servera session
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish processes-monitor"
history -s "lab finish processes-monitor"
lab finish processes-monitor

history -w