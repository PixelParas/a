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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start perms-cli"
history -s "lab start perms-cli"
lab start perms-cli

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Create /home/consultants directory
echo "[root@servera ~]# mkdir /home/consultants"
history -s "mkdir /home/consultants"
ssh student@servera "sudo mkdir -p /home/consultants"

# Step 3: Change group ownership to consultants
echo "[root@servera ~]# chown :consultants /home/consultants"
history -s "chown :consultants /home/consultants"
ssh student@servera "sudo chown :consultants /home/consultants"

# Step 4: Verify current permissions
echo "[root@servera ~]# ls -ld /home/consultants"
history -s "ls -ld /home/consultants"
ssh student@servera "ls -ld /home/consultants"

# Step 5: Add write permission to group (symbolic method) and verify
echo "[root@servera ~]# chmod g+w /home/consultants"
history -s "chmod g+w /home/consultants"
ssh student@servera "sudo chmod g+w /home/consultants"

echo "[root@servera ~]# ls -ld /home/consultants"
history -s "ls -ld /home/consultants"
ssh student@servera "ls -ld /home/consultants"

# Step 6: Set permissions to 770 (octal method) and verify
echo "[root@servera ~]# chmod 770 /home/consultants"
history -s "chmod 770 /home/consultants"
ssh student@servera "sudo chmod 770 /home/consultants"

echo "[root@servera ~]# ls -ld /home/consultants"
history -s "ls -ld /home/consultants"
ssh student@servera "ls -ld /home/consultants"

# Step 7: Exit root and switch to consultant1
echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ su - consultant1"
history -s "su - consultant1"

# Step 8: Create file as consultant1 and list directory contents
echo "[consultant1@servera ~]$ cd /home/consultants"
history -s "cd /home/consultants"

echo "[consultant1@servera consultants]$ touch consultant1.txt"
history -s "touch consultant1.txt"
ssh student@servera "sudo -u consultant1 touch /home/consultants/consultant1.txt"

echo "[consultant1@servera consultants]$ ls"
history -s "ls"
ssh student@servera "sudo -u consultant1 ls /home/consultants"

# Step 9: Exit consultant1 session and switch to consultant2
echo "[consultant1@servera consultants]$ exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ su - consultant2"
history -s "su - consultant2"

# Step 10: Create file as consultant2 and verify directory contents
echo "[consultant2@servera ~]$ cd /home/consultants/"
history -s "cd /home/consultants/"

echo "[consultant2@servera consultants]$ touch consultant2.txt"
history -s "touch consultant2.txt"
ssh student@servera "sudo -u consultant2 touch /home/consultants/consultant2.txt"

echo "[consultant2@servera consultants]$ ls"
history -s "ls"
ssh student@servera "sudo -u consultant2 ls /home/consultants"

# Step 11: Exit user sessions and return to workstation
echo "[consultant2@servera consultants]$ exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish perms-cli"
history -s "lab finish perms-cli"
lab finish perms-cli

history -w