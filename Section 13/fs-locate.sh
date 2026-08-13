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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start fs-locate"
history -s "lab start fs-locate"
lab start fs-locate

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Update locatedb database manually
echo "[student@servera ~]$ sudo updatedb"
echo "[sudo] password for student: student"
history -s "sudo updatedb"
ssh student@servera "echo student | sudo -S updatedb"

# Step 3: Locate logrotate.conf configuration file
echo "[student@servera ~]$ locate logrotate.conf"
history -s "locate logrotate.conf"
ssh student@servera "locate logrotate.conf"

# Step 4: Locate networkmanager.conf configuration file ignoring case sensitivity
echo "[student@servera ~]$ locate -i networkmanager.conf"
history -s "locate -i networkmanager.conf"
ssh student@servera "locate -i networkmanager.conf"

# Step 5: List files in /var/lib owned by chrony user
echo "[student@servera ~]$ sudo find /var/lib -user chrony"
history -s "sudo find /var/lib -user chrony"
ssh student@servera "echo student | sudo -S find /var/lib -user chrony"

# Step 6: List files in /var owned by root and group mail
echo "[student@servera ~]$ sudo find /var -user root -group mail"
history -s "sudo find /var -user root -group mail"
ssh student@servera "echo student | sudo -S find /var -user root -group mail"

# Step 7: List files in /usr/bin size greater than 50k
echo "[student@servera ~]$ find /usr/bin -size +50k"
history -s "find /usr/bin -size +50k"
ssh student@servera "find /usr/bin -size +50k"

# Step 8: List files in /home/student changed in the last 120 minutes
echo "[student@servera ~]$ find /home/student -mmin -120"
history -s "find /home/student -mmin -120"
ssh student@servera "find /home/student -mmin -120"

# Step 9: List block device files in /dev
echo "[student@servera ~]$ find /dev -type b"
history -s "find /dev -type b"
ssh student@servera "find /dev -type b"

# Step 10: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish fs-locate"
history -s "lab finish fs-locate"
lab finish fs-locate

history -w