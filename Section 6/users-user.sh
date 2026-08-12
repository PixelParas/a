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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start users-user"
history -s "lab start users-user"
lab start users-user

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Create operator1 user and view /etc/passwd
echo "[root@servera ~]# useradd operator1"
history -s "useradd operator1"
ssh student@servera "sudo useradd operator1"

echo "[root@servera ~]# tail /etc/passwd"
history -s "tail /etc/passwd"
ssh student@servera "tail /etc/passwd"

# Step 3: Set password for operator1
echo "[root@servera ~]# passwd operator1"
history -s "passwd operator1"
ssh student@servera "echo redhat | sudo passwd --stdin operator1"

# Step 4: Create operator2 and operator3, set their passwords
echo "[root@servera ~]# useradd operator2"
history -s "useradd operator2"
ssh student@servera "sudo useradd operator2"

echo "[root@servera ~]# passwd operator2"
history -s "passwd operator2"
ssh student@servera "echo redhat | sudo passwd --stdin operator2"

echo "[root@servera ~]# useradd operator3"
history -s "useradd operator3"
ssh student@servera "sudo useradd operator3"

echo "[root@servera ~]# passwd operator3"
history -s "passwd operator3"
ssh student@servera "echo redhat | sudo passwd --stdin operator3"

# Step 5: Update comments for operator1 and operator2 and verify
echo "[root@servera ~]# usermod -c \"Operator One\" operator1"
history -s "usermod -c \"Operator One\" operator1"
ssh student@servera "sudo usermod -c 'Operator One' operator1"

echo "[root@servera ~]# usermod -c \"Operator Two\" operator2"
history -s "usermod -c \"Operator Two\" operator2"
ssh student@servera "sudo usermod -c 'Operator Two' operator2"

echo "[root@servera ~]# tail /etc/passwd"
history -s "tail /etc/passwd"
ssh student@servera "tail /etc/passwd"

# Step 6: Remove operator3 user and home directory, then verify
echo "[root@servera ~]# userdel -r operator3"
history -s "userdel -r operator3"
ssh student@servera "sudo userdel -r operator3"

echo "[root@servera ~]# tail /etc/passwd"
history -s "tail /etc/passwd"
ssh student@servera "tail /etc/passwd"

echo "[root@servera ~]# ls -l /home"
history -s "ls -l /home"
ssh student@servera "ls -l /home"

# Step 7: Exit root and logout from servera
echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish users-user"
history -s "lab finish users-user"
lab finish users-user

history -w