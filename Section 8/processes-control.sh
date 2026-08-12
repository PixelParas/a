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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start processes-control"
history -s "lab start processes-control"
lab start processes-control

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Create bin directory
echo "[student@servera ~]$ mkdir /home/student/bin"
history -s "mkdir /home/student/bin"
ssh student@servera "mkdir -p /home/student/bin"

# Step 3: Create control script in /home/student/bin
echo "[student@servera ~]$ vim /home/student/bin/control"
history -s "vim /home/student/bin/control"
ssh student@servera "cat << 'EOF' > /home/student/bin/control
#!/bin/bash
while true; do
  echo -n \"\$@ \" >> ~/control_outfile
  sleep 1
done
EOF"

# Step 4: Make control script executable
echo "[student@servera ~]$ chmod +x /home/student/bin/control"
history -s "chmod +x /home/student/bin/control"
ssh student@servera "chmod +x /home/student/bin/control"

# Step 5: Execute control script with argument 'technical' and suspend it
echo "[student@servera ~]$ control technical"
history -s "control technical"

echo "^Z"
echo "[1]+  Stopped                 control technical"

# Right terminal simulation: tail output check
echo "[student@servera ~]$ tail -f ~/control_outfile"
history -s "tail -f ~/control_outfile"

# Step 6: View jobs and restart job in background
echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 control technical"

echo "[student@servera ~]$ bg"
history -s "bg"
echo "[1]+ control technical &"

echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Running                 control technical &"

# Step 7: Start two more processes in background
echo "[student@servera ~]$ control documents &"
history -s "control documents &"
echo "[2] 6579"

echo "[student@servera ~]$ control database &"
history -s "control database &"
echo "[3] 6654"

# Step 8: View running processes
echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]   Running                 control technical &"
echo "[2]-  Running                 control documents &"
echo "[3]+  Running                 control database &"

# Step 9: Foreground 'control technical' and suspend it
echo "[student@servera ~]$ fg %1"
history -s "fg %1"
echo "control technical^Z"
echo "[1]+  Stopped                 control technical"

echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 control technical"
echo "[2]   Running                 control documents &"
echo "[3]-  Running                 control database &"

# Step 10: Foreground 'control documents' and terminate it
echo "[student@servera ~]$ fg %2"
history -s "fg %2"
echo "control documents"
echo "^C"

echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 control technical"
echo "[3]-  Running                 control database &"

# Step 11: Display process list with status
echo "[student@servera ~]$ ps jT"
history -s "ps jT"
ssh student@servera "ps jT"

# Step 12: Foreground 'control database' and terminate it
echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 control technical"
echo "[3]-  Running                 control database &"

echo "[student@servera ~]$ fg %3"
history -s "fg %3"
echo "control database"
echo "^C"

echo "[student@servera ~]$ jobs"
history -s "jobs"
echo "[1]+  Stopped                 control technical"

# Step 13: Clean up control_outfile and kill background processes on servera
echo "^C"
echo "[student@servera ~]$ rm ~/control_outfile"
history -s "rm ~/control_outfile"
ssh student@servera "pkill -f /home/student/bin/control; rm -f ~/control_outfile"

# Step 14: Exit servera session
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish processes-control"
history -s "lab finish processes-control"
lab finish processes-control

history -w