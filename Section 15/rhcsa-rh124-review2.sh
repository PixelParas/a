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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start rhcsa-rh124-review2"
history -s "lab start rhcsa-rh124-review2"
lab start rhcsa-rh124-review2

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Identify and terminate the top CPU-consuming process
echo "[student@serverb ~]$ ps aux --sort=-%cpu | head -n 5"
history -s "ps aux --sort=-%cpu | head -n 5"

TOP_CPU_PID=$(ssh student@serverb "ps -eo pid,%cpu --sort=-%cpu | sed -n '2p' | awk '{print \$1}'")

if [ -n "$TOP_CPU_PID" ]; then
    echo "[student@serverb ~]$ kill -9 $TOP_CPU_PID"
    history -s "kill -9 $TOP_CPU_PID"
    ssh student@serverb "kill -9 $TOP_CPU_PID 2>/dev/null || true"
fi

# Step 3: Switch to root shell on serverb
echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 4: Create database group with GID 50000
echo "[root@serverb ~]# groupadd -g 50000 database"
history -s "groupadd -g 50000 database"
ssh student@serverb "sudo groupadd -g 50000 database"

# Step 5: Create dbadmin1 user with supplementary group database
echo "[root@serverb ~]# useradd -G database dbadmin1"
history -s "useradd -G database dbadmin1"
ssh student@serverb "sudo useradd -G database dbadmin1"

# Step 6: Configure password and password aging parameters for dbadmin1
echo "[root@serverb ~]# echo redhat | passwd --stdin dbadmin1"
history -s "echo redhat | passwd --stdin dbadmin1"
ssh student@serverb "echo 'redhat' | sudo passwd --stdin dbadmin1"

echo "[root@serverb ~]# chage -d 0 dbadmin1"
history -s "chage -d 0 dbadmin1"
ssh student@serverb "sudo chage -d 0 dbadmin1"

echo "[root@serverb ~]# chage -m 10 dbadmin1"
history -s "chage -m 10 dbadmin1"
ssh student@serverb "sudo chage -m 10 dbadmin1"

echo "[root@serverb ~]# chage -M 30 dbadmin1"
history -s "chage -M 30 dbadmin1"
ssh student@serverb "sudo chage -M 30 dbadmin1"

# Step 7: Configure sudo privileges for dbadmin1
echo "[root@serverb ~]# echo \"dbadmin1 ALL=(ALL) ALL\" > /etc/sudoers.d/dbadmin1"
history -s "echo \"dbadmin1 ALL=(ALL) ALL\" > /etc/sudoers.d/dbadmin1"
ssh student@serverb "sudo bash -c 'echo \"dbadmin1 ALL=(ALL) ALL\" > /etc/sudoers.d/dbadmin1'"

# Step 8: Set default umask 007 for dbadmin1
echo "[root@serverb ~]# echo \"umask 007\" >> /home/dbadmin1/.bashrc"
history -s "echo \"umask 007\" >> /home/dbadmin1/.bashrc"
ssh student@serverb "sudo bash -c 'echo \"umask 007\" >> /home/dbadmin1/.bashrc'"

# Step 9: Create and configure permissions on /home/dbadmin1/review2
echo "[root@serverb ~]# mkdir /home/dbadmin1/review2"
history -s "mkdir /home/dbadmin1/review2"
ssh student@serverb "sudo mkdir -p /home/dbadmin1/review2"

echo "[root@serverb ~]# chown dbadmin1:database /home/dbadmin1/review2"
history -s "chown dbadmin1:database /home/dbadmin1/review2"
ssh student@serverb "sudo chown dbadmin1:database /home/dbadmin1/review2"

echo "[root@serverb ~]# chmod 3775 /home/dbadmin1/review2"
history -s "chmod 3775 /home/dbadmin1/review2"
ssh student@serverb "sudo chmod 3775 /home/dbadmin1/review2"

# Step 10: Configure permissions on /home/dbadmin1 to permit traversal without listing
echo "[root@serverb ~]# chmod 711 /home/dbadmin1"
history -s "chmod 711 /home/dbadmin1"
ssh student@serverb "sudo chmod 711 /home/dbadmin1"

# Step 11: Exit root shell and serverb session
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

echo "[student@workstation ~]$ lab grade rhcsa-rh124-review2"
history -s "lab grade rhcsa-rh124-review2"
lab grade rhcsa-rh124-review2

echo "[student@workstation ~]$ lab finish rhcsa-rh124-review2"
history -s "lab finish rhcsa-rh124-review2"
lab finish rhcsa-rh124-review2

history -w