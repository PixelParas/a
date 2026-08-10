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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start users-superuser"
history -s "lab start users-superuser"
lab start users-superuser

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Explore student environment on servera
echo "[student@servera ~]$ id"
history -s "id"
ssh student@servera "id"

echo "[student@servera ~]$ pwd"
history -s "pwd"
ssh student@servera "pwd"

echo "[student@servera ~]$ echo \$HOME"
history -s "echo \$HOME"
ssh student@servera "echo \$HOME"

echo "[student@servera ~]$ echo \$PATH"
history -s "echo \$PATH"
ssh student@servera "echo \$PATH"

# Step 3: Switch to root non-login shell (sudo su) and explore environment
echo "[student@servera ~]$ sudo su"
history -s "sudo su"

echo "[root@servera student]# id"
history -s "id"
ssh student@servera "sudo id"

echo "[root@servera student]# pwd"
history -s "pwd"
echo "/home/student"

echo "[root@servera student]# echo \$HOME"
history -s "echo \$HOME"
echo "/root"

echo "[root@servera student]# echo \$PATH"
history -s "echo \$PATH"
ssh student@servera "sudo su -c 'echo \$PATH'"

echo "[root@servera student]# exit"
echo "exit"
history -s "exit"

# Step 4: Switch to root login shell (sudo su -) and explore environment
echo "[student@servera ~]$ sudo su -"
history -s "sudo su -"

echo "[root@servera ~]# id"
history -s "id"
ssh student@servera "sudo su - -c 'id'"

echo "[root@servera ~]# pwd"
history -s "pwd"
echo "/root"

echo "[root@servera ~]# echo \$HOME"
history -s "echo \$HOME"
echo "/root"

echo "[root@servera ~]# echo \$PATH"
history -s "echo \$PATH"
ssh student@servera "sudo su - -c 'echo \$PATH'"

echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

# Step 5: Check operator1 sudo privileges
echo "[student@servera ~]$ sudo cat /etc/sudoers.d/operator1"
history -s "sudo cat /etc/sudoers.d/operator1"
ssh student@servera "sudo cat /etc/sudoers.d/operator1"

# Step 6: Switch to operator1 user
echo "[student@servera ~]$ su - operator1"
history -s "su - operator1"

# Step 7: Test reading log without and with sudo
echo "[operator1@servera ~]$ tail -5 /var/log/messages"
history -s "tail -5 /var/log/messages"
ssh student@servera "sudo -u operator1 tail -5 /var/log/messages 2>&1 || true"

echo "[operator1@servera ~]$ sudo tail -5 /var/log/messages"
history -s "sudo tail -5 /var/log/messages"
ssh student@servera "sudo tail -5 /var/log/messages"

# Step 8: Test copying motd file without and with sudo
echo "[operator1@servera ~]$ cp /etc/motd /etc/motdOLD"
history -s "cp /etc/motd /etc/motdOLD"
ssh student@servera "sudo -u operator1 cp /etc/motd /etc/motdOLD 2>&1 || true"

echo "[operator1@servera ~]$ sudo cp /etc/motd /etc/motdOLD"
history -s "sudo cp /etc/motd /etc/motdOLD"
ssh student@servera "sudo cp /etc/motd /etc/motdOLD"

# Step 9: Test deleting motdOLD file without and with sudo
echo "[operator1@servera ~]$ rm /etc/motdOLD"
history -s "rm /etc/motdOLD"
ssh student@servera "sudo -u operator1 rm /etc/motdOLD 2>&1 || true"

echo "[operator1@servera ~]$ sudo rm /etc/motdOLD"
history -s "sudo rm /etc/motdOLD"
ssh student@servera "sudo rm -f /etc/motdOLD"

# Step 10: Exit operator1 user shell and servera session
echo "[operator1@servera ~]$ exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish users-superuser"
history -s "lab finish users-superuser"
lab finish users-superuser

history -w