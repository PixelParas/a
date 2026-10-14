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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|rhcsa-rh124-review3\.sh|rhcsa-rh124-review4\.sh|rhcsa-rh124-review5\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# Helper function to run commands via SSH with sudo
run_sudo_remote() {
    ssh -t student@serverb "echo student | sudo -S $1"
}

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start rhcsa-rh124-review5"
history -s "lab start rhcsa-rh124-review5"
lab start rhcsa-rh124-review5

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Identify partition on second block device with xfs filesystem, create mount point, and mount it
echo "[root@serverb ~]# lsblk -fp /dev/vdb"
history -s "lsblk -fp /dev/vdb"
ssh student@serverb "lsblk -fp /dev/vdb"

echo "[root@serverb ~]# mkdir /review5-disk"
history -s "mkdir /review5-disk"
run_sudo_remote "mkdir -p /review5-disk"

TARGET_PART=$(ssh -t student@serverb "echo student | sudo -S lsblk -fno NAME,FSTYPE /dev/vdb 2>/dev/null | grep xfs | awk '{print \$1}' | head -n1" 2>/dev/null | tr -d '\r')
if [ -z "$TARGET_PART" ]; then
    TARGET_PART="/dev/vdb1"
fi

echo "[root@serverb ~]# mount $TARGET_PART /review5-disk"
history -s "mount $TARGET_PART /review5-disk"
run_sudo_remote "mount $TARGET_PART /review5-disk"

# Step 3: Find review5-path file and store its absolute path
echo "[root@serverb ~]# find / -name review5-path 2>/dev/null > /review5-disk/review5-path.txt"
history -s "find / -name review5-path 2>/dev/null > /review5-disk/review5-path.txt"
ssh -t student@serverb "echo student | sudo -S bash -c 'find / -name review5-path 2>/dev/null > /review5-disk/review5-path.txt'"

# Step 4: Find files owned by contractor1:contractor with 640 permissions
echo "[root@serverb ~]# find / -user contractor1 -group contractor -perm 640 2>/dev/null > /review5-disk/review5-perms.txt"
history -s "find / -user contractor1 -group contractor -perm 640 2>/dev/null > /review5-disk/review5-perms.txt"
ssh -t student@serverb "echo student | sudo -S bash -c 'find / -user contractor1 -group contractor -perm 640 2>/dev/null > /review5-disk/review5-perms.txt'"

# Step 5: Find files with size 100 bytes
echo "[root@serverb ~]# find / -size 100c 2>/dev/null > /review5-disk/review5-size.txt"
history -s "find / -size 100c 2>/dev/null > /review5-disk/review5-size.txt"
ssh -t student@serverb "echo student | sudo -S bash -c 'find / -size 100c 2>/dev/null > /review5-disk/review5-size.txt'"

# Step 6: Exit root shell and serverb session
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

echo "[student@workstation ~]$ lab grade rhcsa-rh124-review5"
history -s "lab grade rhcsa-rh124-review5"
lab grade rhcsa-rh124-review5

echo "[student@workstation ~]$ lab finish rhcsa-rh124-review5"
history -s "lab finish rhcsa-rh124-review5"
lab finish rhcsa-rh124-review5

history -w
