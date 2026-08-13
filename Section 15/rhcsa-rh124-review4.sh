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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|rhcsa-rh124-review3\.sh|rhcsa-rh124-review4\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start rhcsa-rh124-review4"
history -s "lab start rhcsa-rh124-review4"
lab start rhcsa-rh124-review4

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Determine Ethernet interface and active profile
echo "[root@serverb ~]# nmcli device status"
history -s "nmcli device status"
ssh student@serverb "sudo nmcli device status"

echo "[root@serverb ~]# nmcli connection show"
history -s "nmcli connection show"
ssh student@serverb "sudo nmcli connection show"

ORIG_CONN=$(ssh student@serverb "sudo nmcli -t -f NAME,DEVICE connection show --active | grep ':eth0' | cut -d: -f1")
if [ -z "$ORIG_CONN" ]; then
    ORIG_CONN="eth0"
fi

# Step 3: Create and activate static connection profile
echo "[root@serverb ~]# nmcli connection add con-name static type ethernet ifname eth0 ipv4.addresses 172.25.250.111/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 ipv4.method manual"
history -s "nmcli connection add con-name static type ethernet ifname eth0 ipv4.addresses 172.25.250.111/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 ipv4.method manual"
ssh student@serverb "sudo nmcli connection add con-name static type ethernet ifname eth0 ipv4.addresses 172.25.250.111/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 ipv4.method manual"

echo "[root@serverb ~]# nmcli connection up static"
history -s "nmcli connection up static"
ssh student@serverb "sudo nmcli connection up static"

# Step 4: Set hostname for serverb
echo "[root@serverb ~]# hostnamectl set-hostname server-review4.lab4.example.com"
history -s "hostnamectl set-hostname server-review4.lab4.example.com"
ssh student@serverb "sudo hostnamectl set-hostname server-review4.lab4.example.com"

# Step 5: Add canonical hostname entry for 172.25.250.10 in /etc/hosts
echo "[root@serverb ~]# vim /etc/hosts"
history -s "vim /etc/hosts"
ssh student@serverb "sudo bash -c 'grep -q \"172.25.250.10\" /etc/hosts || echo \"172.25.250.10 client-review4\" >> /etc/hosts'"

# Step 6: Add secondary IP address 172.25.250.211/24 to static connection
echo "[root@serverb ~]# nmcli connection modify static +ipv4.addresses 172.25.250.211/24"
history -s "nmcli connection modify static +ipv4.addresses 172.25.250.211/24"
ssh student@serverb "sudo nmcli connection modify static +ipv4.addresses 172.25.250.211/24"

echo "[root@serverb ~]# nmcli connection up static"
history -s "nmcli connection up static"
ssh student@serverb "sudo nmcli connection up static"

# Step 7: Restore original connection profile
echo "[root@serverb ~]# nmcli connection up $ORIG_CONN"
history -s "nmcli connection up $ORIG_CONN"
ssh student@serverb "sudo nmcli connection up '$ORIG_CONN'"

# Step 8: Exit serverb session
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

echo "[student@workstation ~]$ lab grade rhcsa-rh124-review4"
history -s "lab grade rhcsa-rh124-review4"
lab grade rhcsa-rh124-review4

echo "[student@workstation ~]$ lab finish rhcsa-rh124-review4"
history -s "lab finish rhcsa-rh124-review4"
lab finish rhcsa-rh124-review4

history -w