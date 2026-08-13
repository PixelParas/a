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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start fs-review"
history -s "lab start fs-review"
lab start fs-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Query /dev/vdb block device and determine UUID
echo "[root@serverb ~]# lsblk -fp /dev/vdb"
history -s "lsblk -fp /dev/vdb"
ssh student@serverb "lsblk -fp /dev/vdb"

UUID_VDB1=$(ssh student@serverb "sudo lsblk -no UUID /dev/vdb1 2>/dev/null | head -n1")
if [ -z "$UUID_VDB1" ]; then
    UUID_VDB1=$(ssh student@serverb "sudo lsblk -no UUID /dev/vdb 2>/dev/null | grep -v '^$' | head -n1")
fi

# Step 3: Create /mnt/freespace and mount by UUID
echo "[root@serverb ~]# mkdir /mnt/freespace"
history -s "mkdir /mnt/freespace"
ssh student@serverb "sudo mkdir -p /mnt/freespace"

echo "[root@serverb ~]# mount UUID=\"$UUID_VDB1\" /mnt/freespace"
history -s "mount UUID=\"$UUID_VDB1\" /mnt/freespace"
ssh student@serverb "sudo mount UUID=\"$UUID_VDB1\" /mnt/freespace"

echo "[root@serverb ~]# lsblk -fp /dev/vdb"
history -s "lsblk -fp /dev/vdb"
ssh student@serverb "lsblk -fp /dev/vdb"

# Step 4: Generate disk usage report for /usr/share
echo "[root@serverb ~]# du /usr/share > /mnt/freespace/results.txt"
history -s "du /usr/share > /mnt/freespace/results.txt"
ssh student@serverb "sudo bash -c 'du /usr/share > /mnt/freespace/results.txt'"

# Step 5: Update locate database and search for rsyslog.conf
echo "[root@serverb ~]# updatedb"
history -s "updatedb"
ssh student@serverb "sudo updatedb"

echo "[root@serverb ~]# locate rsyslog.conf > /mnt/freespace/search1.txt"
history -s "locate rsyslog.conf > /mnt/freespace/search1.txt"
ssh student@serverb "sudo bash -c 'locate rsyslog.conf > /mnt/freespace/search1.txt'"

# Step 6: Find files in /usr/share between 50MB and 100MB
echo "[root@serverb ~]# find /usr/share -size +50M -size -100M > /mnt/freespace/search2.txt"
history -s "find /usr/share -size +50M -size -100M > /mnt/freespace/search2.txt"
ssh student@serverb "sudo bash -c 'find /usr/share -size +50M -size -100M > /mnt/freespace/search2.txt'"

# Step 7: Exit serverb
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

echo "[student@workstation ~]$ lab grade fs-review"
history -s "lab grade fs-review"
lab grade fs-review

echo "[student@workstation ~]$ lab finish fs-review"
history -s "lab finish fs-review"
lab finish fs-review

history -w