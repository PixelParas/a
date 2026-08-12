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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start perms-default"
history -s "lab start perms-default"
lab start perms-default

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to operator1
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ su - operator1"
history -s "su - operator1"

# Step 2: Check current umask
echo "[operator1@servera ~]$ umask"
history -s "umask"
ssh student@servera "sudo -u operator1 bash -c 'umask'"

# Step 3: Create /tmp/shared directory and check permissions
echo "[operator1@servera ~]$ mkdir /tmp/shared"
history -s "mkdir /tmp/shared"
ssh student@servera "sudo -u operator1 mkdir -p /tmp/shared"

echo "[operator1@servera ~]$ ls -ld /tmp/shared"
history -s "ls -ld /tmp/shared"
ssh student@servera "ls -ld /tmp/shared"

# Step 4: Create defaults file and verify permissions
echo "[operator1@servera ~]$ touch /tmp/shared/defaults"
history -s "touch /tmp/shared/defaults"
ssh student@servera "sudo -u operator1 touch /tmp/shared/defaults"

echo "[operator1@servera ~]$ ls -l /tmp/shared/defaults"
history -s "ls -l /tmp/shared/defaults"
ssh student@servera "ls -l /tmp/shared/defaults"

# Step 5: Change group ownership to operators and verify
echo "[operator1@servera ~]$ chown :operators /tmp/shared"
history -s "chown :operators /tmp/shared"
ssh student@servera "sudo -u operator1 chown :operators /tmp/shared"

echo "[operator1@servera ~]$ ls -ld /tmp/shared"
history -s "ls -ld /tmp/shared"
ssh student@servera "ls -ld /tmp/shared"

# Step 6: Create group file and list permissions
echo "[operator1@servera ~]$ touch /tmp/shared/group"
history -s "touch /tmp/shared/group"
ssh student@servera "sudo -u operator1 touch /tmp/shared/group"

echo "[operator1@servera ~]$ ls -l /tmp/shared/group"
history -s "ls -l /tmp/shared/group"
ssh student@servera "ls -l /tmp/shared/group"

# Step 7: Set setgid bit on /tmp/shared
echo "[operator1@servera ~]$ chmod g+s /tmp/shared"
history -s "chmod g+s /tmp/shared"
ssh student@servera "sudo -u operator1 chmod g+s /tmp/shared"

# Step 8: Create ops_db.txt and verify group ownership
echo "[operator1@servera ~]$ touch /tmp/shared/ops_db.txt"
history -s "touch /tmp/shared/ops_db.txt"
ssh student@servera "sudo -u operator1 touch /tmp/shared/ops_db.txt"

echo "[operator1@servera ~]$ ls -l /tmp/shared/ops_db.txt"
history -s "ls -l /tmp/shared/ops_db.txt"
ssh student@servera "ls -l /tmp/shared/ops_db.txt"

# Step 9: Create ops_net.txt and check permissions
echo "[operator1@servera ~]$ touch /tmp/shared/ops_net.txt"
history -s "touch /tmp/shared/ops_net.txt"
ssh student@servera "sudo -u operator1 touch /tmp/shared/ops_net.txt"

echo "[operator1@servera ~]$ ls -l /tmp/shared/ops_net.txt"
history -s "ls -l /tmp/shared/ops_net.txt"
ssh student@servera "ls -l /tmp/shared/ops_net.txt"

# Step 10: Change umask to 027 and create ops_prod.txt
echo "[operator1@servera ~]$ umask 027"
history -s "umask 027"

echo "[operator1@servera ~]$ umask"
history -s "umask"
echo "0027"

echo "[operator1@servera ~]$ touch /tmp/shared/ops_prod.txt"
history -s "touch /tmp/shared/ops_prod.txt"
ssh student@servera "sudo -u operator1 bash -c 'umask 027 && touch /tmp/shared/ops_prod.txt'"

echo "[operator1@servera ~]$ ls -l /tmp/shared/ops_prod.txt"
history -s "ls -l /tmp/shared/ops_prod.txt"
ssh student@servera "ls -l /tmp/shared/ops_prod.txt"

# Step 11: Connect in new session as operator1
echo "[student@workstation ~]$ ssh operator1@servera"
history -s "ssh operator1@servera"

echo "[operator1@servera ~]$ umask"
history -s "umask"
ssh student@servera "sudo -u operator1 bash -c 'umask'"

# Step 12: Configure persistent umask 007 in ~/.bashrc
echo "[operator1@servera ~]$ echo \"umask 007\" >> ~/.bashrc"
history -s "echo \"umask 007\" >> ~/.bashrc"
ssh student@servera "sudo -u operator1 bash -c 'echo \"umask 007\" >> ~/.bashrc'"

echo "[operator1@servera ~]$ cat ~/.bashrc"
history -s "cat ~/.bashrc"
ssh student@servera "sudo -u operator1 cat ~/.bashrc"

echo "[operator1@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 13: Re-login as operator1 to reload bashrc and create ops_prod2.txt
echo "[student@workstation ~]$ ssh operator1@servera"
history -s "ssh operator1@servera"

echo "[operator1@servera ~]$ umask"
history -s "umask"
ssh student@servera "sudo -u operator1 bash -l -c 'umask'"

echo "[operator1@servera ~]$ touch /tmp/shared/ops_prod2.txt"
history -s "touch /tmp/shared/ops_prod2.txt"
ssh student@servera "sudo -u operator1 bash -l -c 'touch /tmp/shared/ops_prod2.txt'"

echo "[operator1@servera ~]$ ls -l /tmp/shared/ops_prod2.txt"
history -s "ls -l /tmp/shared/ops_prod2.txt"
ssh student@servera "ls -l /tmp/shared/ops_prod2.txt"

# Step 14: Close user session and return to workstation
echo "[operator1@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish perms-default"
history -s "lab finish perms-default"
lab finish perms-default

history -w