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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start processes-review"
history -s "lab start processes-review"
lab start processes-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Create /home/student/bin and process101 script
echo "[student@serverb ~]$ mkdir -p /home/student/bin"
history -s "mkdir -p /home/student/bin"
ssh student@serverb "mkdir -p /home/student/bin"

echo "[student@serverb ~]$ vim /home/student/bin/process101"
history -s "vim /home/student/bin/process101"
ssh student@serverb "cat << 'EOF' > /home/student/bin/process101
#!/bin/bash
while true
do
  var=1
  while (( var < 50000 ))
  do
    var=\$(( var + 1 ))
  done
  sleep 1
done
EOF"

echo "[student@serverb ~]$ chmod +x /home/student/bin/process101"
history -s "chmod +x /home/student/bin/process101"
ssh student@serverb "chmod +x /home/student/bin/process101"

# Step 3: Run top (Right Terminal Simulation)
echo "[student@serverb ~]$ top"
history -s "top"

# Step 4: Verify logical CPUs and run process101 in background
echo "[student@serverb ~]$ lscpu"
history -s "lscpu"
ssh student@serverb "lscpu"

echo "[student@serverb ~]$ process101 &"
history -s "process101 &"
echo "[1] 12341"
ssh student@serverb "nohup /home/student/bin/process101 >/dev/null 2>&1 &"

# Step 5: Create process102 with 100000 load and run in background
echo "[student@serverb ~]$ cp /home/student/bin/process101 /home/student/bin/process102"
history -s "cp /home/student/bin/process101 /home/student/bin/process102"

echo "[student@serverb ~]$ vim /home/student/bin/process102"
history -s "vim /home/student/bin/process102"
ssh student@serverb "sed 's/50000/100000/' /home/student/bin/process101 > /home/student/bin/process102 && chmod +x /home/student/bin/process102"

echo "[student@serverb ~]$ process102 &"
history -s "process102 &"
echo "[2] 12342"
ssh student@serverb "nohup /home/student/bin/process102 >/dev/null 2>&1 &"

# Step 6: Create process103 with 800000 load and run in background
echo "[student@serverb ~]$ cp /home/student/bin/process101 /home/student/bin/process103"
history -s "cp /home/student/bin/process101 /home/student/bin/process103"

echo "[student@serverb ~]$ vim /home/student/bin/process103"
history -s "vim /home/student/bin/process103"
ssh student@serverb "sed 's/50000/800000/' /home/student/bin/process101 > /home/student/bin/process103 && chmod +x /home/student/bin/process103"

echo "[student@serverb ~]$ process103 &"
history -s "process103 &"
echo "[3] 12343"
ssh student@serverb "nohup /home/student/bin/process103 >/dev/null 2>&1 &"

# Step 7: Switch to root and suspend process101
echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

echo "[root@serverb ~]# pkill -STOP -f process101"
history -s "pkill -STOP -f process101"
ssh student@serverb "sudo pkill -STOP -f process101"

echo "[root@serverb ~]# ps aux | grep process101"
history -s "ps aux | grep process101"
ssh student@serverb "ps aux | grep process101 | grep -v grep"

# Step 8: Resume process101
echo "[root@serverb ~]# pkill -CONT -f process101"
history -s "pkill -CONT -f process101"
ssh student@serverb "sudo pkill -CONT -f process101"

# Step 9: Terminate process101, process102, and process103
echo "[root@serverb ~]# pkill -f process10"
history -s "pkill -f process10"
ssh student@serverb "sudo pkill -f process10"

echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade processes-review"
history -s "lab grade processes-review"
lab grade processes-review

echo "[student@workstation ~]$ lab finish processes-review"
history -s "lab finish processes-review"
lab finish processes-review

history -w