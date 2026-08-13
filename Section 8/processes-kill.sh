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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start processes-kill"
history -s "lab start processes-kill"
lab start processes-kill

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Create bin directory and instance script
echo "[student@servera ~]$ mkdir /home/student/bin"
history -s "mkdir /home/student/bin"
ssh student@servera "mkdir -p /home/student/bin"

echo "[student@servera ~]$ cd /home/student/bin"
history -s "cd /home/student/bin"

echo "[student@servera bin]$ vim /home/student/bin/instance"
history -s "vim /home/student/bin/instance"
ssh student@servera "cat << 'EOF' > /home/student/bin/instance
#!/bin/bash
while true; do
  echo -n \"\$@ \" >> ~/instance_outfile
  sleep 5
done
EOF"

echo "[student@servera bin]$ chmod +x /home/student/bin/instance"
history -s "chmod +x /home/student/bin/instance"
ssh student@servera "chmod +x /home/student/bin/instance"

# Step 3: Start background instance processes
echo "[student@servera bin]$ instance network &"
history -s "instance network &"
echo "[1] 3460"

echo "[student@servera bin]$ instance interface &"
history -s "instance interface &"
echo "[2] 3482"

echo "[student@servera bin]$ instance connection &"
history -s "instance connection &"
echo "[3] 3516"

# Right terminal simulation: tail output check
echo "[student@servera ~]$ tail -f ~/instance_outfile"
history -s "tail -f ~/instance_outfile"

# Step 4: List existing jobs
echo "[student@servera bin]$ jobs"
history -s "jobs"
echo "[1]   Running                 instance network &"
echo "[2]-  Running                 instance interface &"
echo "[3]+  Running                 instance connection &"

# Step 5: Stop instance network process (SIGSTOP)
echo "[student@servera bin]$ kill -SIGSTOP %1"
history -s "kill -SIGSTOP %1"
echo "[1]+  Stopped                 instance network"

echo "[student@servera bin]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 instance network"
echo "[2]   Running                 instance interface &"
echo "[3]-  Running                 instance connection &"

# Step 6: Terminate instance interface process (SIGTERM)
echo "[student@servera bin]$ kill -SIGTERM %2"
history -s "kill -SIGTERM %2"

echo "[student@servera bin]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 instance network"
echo "[2]   Terminated              instance interface"
echo "[3]-  Running                 instance connection &"

# Step 7: Resume instance network process (SIGCONT)
echo "[student@servera bin]$ kill -SIGCONT %1"
history -s "kill -SIGCONT %1"

echo "[student@servera bin]$ jobs"
history -s "jobs"
echo "[1]+  Running                 instance network &"
echo "[3]-  Running                 instance connection &"

# Step 8: Terminate remaining processes
echo "[student@servera bin]$ kill -SIGTERM %1"
history -s "kill -SIGTERM %1"

echo "[student@servera bin]$ kill -SIGTERM %3"
history -s "kill -SIGTERM %3"
echo "[1]+ Terminated              instance network"

echo "[student@servera bin]$ jobs"
history -s "jobs"
echo "[3]+ Terminated              instance connection"

# Step 9: List running processes and kill tail process
echo "[student@servera bin]$ ps -ef | grep tail"
history -s "ps -ef | grep tail"
echo "student   4581 31358  0 10:02 pts/0    00:00:00 tail -f /home/student/instance_outfile"
echo "student   4869  2252  0 10:33 pts/1    00:00:00 grep --color=auto tail"

echo "[student@servera bin]$ pkill -SIGTERM tail"
history -s "pkill -SIGTERM tail"

echo "[student@servera bin]$ ps -ef | grep tail"
history -s "ps -ef | grep tail"
echo "student   4874  2252  0 10:36 pts/1    00:00:00 grep --color=auto tail"

# Clean up remote processes and output file
ssh student@servera "pkill -f /home/student/bin/instance; pkill -f 'tail -f /home/student/instance_outfile'; rm -f ~/instance_outfile"

# Step 10: Exit servera session
echo "[student@servera bin]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish processes-kill"
history -s "lab finish processes-kill"
lab finish processes-kill

history -w