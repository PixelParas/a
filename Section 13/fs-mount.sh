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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start fs-mount"
history -s "lab start fs-mount"
lab start fs-mount

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Create mount point directory /mnt/part1
echo "[root@servera ~]# mkdir /mnt/part1"
history -s "mkdir /mnt/part1"
ssh student@servera "sudo mkdir -p /mnt/part1"

# Step 3: Query file-system UUID for /dev/vdb1
echo "[root@servera ~]# lsblk -fp /dev/vdb"
history -s "lsblk -fp /dev/vdb"
ssh student@servera "lsblk -fp /dev/vdb"

UUID_VDB1=$(ssh student@servera "sudo lsblk -no UUID /dev/vdb1 2>/dev/null | head -n1")
if [ -z "$UUID_VDB1" ]; then
    UUID_VDB1=$(ssh student@servera "sudo lsblk -no UUID /dev/vdb 2>/dev/null | grep -v '^$' | head -n1")
fi

# Step 4: Mount the partition using UUID
echo "[root@servera ~]# mount UUID=\"$UUID_VDB1\" /mnt/part1"
history -s "mount UUID=\"$UUID_VDB1\" /mnt/part1"
ssh student@servera "sudo mount UUID=\"$UUID_VDB1\" /mnt/part1"

# Step 5: Verify mount on /mnt/part1
echo "[root@servera ~]# lsblk -fp /dev/vdb"
history -s "lsblk -fp /dev/vdb"
ssh student@servera "lsblk -fp /dev/vdb"

# Step 6: Create test directory and file inside /mnt/part1
echo "[root@servera ~]# cd /mnt/part1"
history -s "cd /mnt/part1"

echo "[root@servera part1]# mkdir testdir"
history -s "mkdir testdir"
ssh student@servera "sudo mkdir -p /mnt/part1/testdir"

echo "[root@servera part1]# touch testdir/newmount"
history -s "touch testdir/newmount"
ssh student@servera "sudo touch /mnt/part1/testdir/newmount"

# Step 7: Attempt umount while target is busy (simulated)
echo "[root@servera part1]# umount /mnt/part1"
echo "umount: /mnt/part1: target is busy."
history -s "umount /mnt/part1"

# Step 8: Change directory out of /mnt/part1 and unmount
echo "[root@servera part1]# cd"
history -s "cd"

echo "[root@servera ~]# umount /mnt/part1"
history -s "umount /mnt/part1"
ssh student@servera "sudo umount /mnt/part1"

# Step 9: Exit servera
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

echo "[student@workstation ~]$ lab finish fs-mount"
history -s "lab finish fs-mount"
lab finish fs-mount

history -w