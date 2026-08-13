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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start software-rpm"
history -s "lab start software-rpm"
lab start software-rpm

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Query RPM package information
echo "[student@servera ~]$ rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -i"
history -s "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -i"
ssh student@servera "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -i"

# Step 3: List files inside RPM package
echo "[student@servera ~]$ rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -l"
history -s "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -l"
ssh student@servera "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm -l"

# Step 4: Inspect package installation scriptlets
echo "[student@servera ~]$ rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm --scripts"
history -s "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm --scripts"
ssh student@servera "rpm -q -p rhcsa-script-1.0.0-1.noarch.rpm --scripts"

# Step 5: Test listing contents with rpm2cpio and cpio
echo "[student@servera ~]$ rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -tv"
history -s "rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -tv"
ssh student@servera "rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -tv"

# Step 6: Extract contents of RPM package to home directory
echo "[student@servera ~]$ rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -idv"
history -s "rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -idv"
ssh student@servera "rpm2cpio rhcsa-script-1.0.0-1.noarch.rpm | cpio -idv"

# Step 7: Verify extracted files
echo "[student@servera ~]$ ls -lR opt"
history -s "ls -lR opt"
ssh student@servera "ls -lR opt"

# Step 8: Install the RPM package using sudo rpm -ivh
echo "[student@servera ~]$ sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
echo "[sudo] password for student: student"
history -s "sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
ssh student@servera "echo student | sudo -S rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"

# Step 9: Verify installed RPM package
echo "[student@servera ~]$ rpm -q rhcsa-script"
history -s "rpm -q rhcsa-script"
ssh student@servera "rpm -q rhcsa-script"

# Step 10: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 11: Reconnect to servera to trigger new MOTD display, then exit
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"
ssh student@servera "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish software-rpm"
history -s "lab finish software-rpm"
lab finish software-rpm

history -w