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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start net-edit"
history -s "lab start net-edit"
lab start net-edit

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Check interfaces and connection details on servera
echo "[student@servera ~]$ ip link"
history -s "ip link"
ssh student@servera "ip link"

echo "[student@servera ~]$ nmcli con show --active"
history -s "nmcli con show --active"
ssh student@servera "nmcli con show --active"

echo "[student@servera ~]$ ls /etc/NetworkManager/system-connections/"
history -s "ls /etc/NetworkManager/system-connections/"
ssh student@servera "ls /etc/NetworkManager/system-connections/"

# Step 3: Switch to root and edit configuration file on servera
echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

ETH0_A=$(ssh student@servera "ip -o link show | grep -i '52:54:00:00:fa:0a' | awk -F': ' '{print \$2}' | head -n1")
if [ -z "$ETH0_A" ]; then
    ETH0_A="eth0"
fi

CON_A=$(ssh student@servera "sudo nmcli -t -f NAME,DEVICE con show --active | grep \":$ETH0_A\" | cut -d: -f1")
if [ -z "$CON_A" ]; then
    CON_A="System eth0"
fi

ssh student@servera "sudo sed -i '/^address1=/a address2=10.0.1.1/24' '/etc/NetworkManager/system-connections/$CON_A.nmconnection'"

echo "[root@servera ~]# nmcli con reload"
history -s "nmcli con reload"
ssh student@servera "sudo nmcli con reload"

echo "[root@servera ~]# nmcli con up \"$CON_A\""
history -s "nmcli con up \"$CON_A\""
ssh student@servera "sudo nmcli con up \"$CON_A\""

echo "[root@servera ~]# ip -br addr show $ETH0_A"
history -s "ip -br addr show $ETH0_A"
ssh student@servera "ip -br addr show $ETH0_A"

# Exit servera
echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 4: Connect to serverb, switch to root, and edit configuration file
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

ETH0_B=$(ssh student@serverb "ip -o link show | grep -i '52:54:00:00:fa:0b\|52:54:00' | awk -F': ' '{print \$2}' | head -n1")
if [ -z "$ETH0_B" ]; then
    ETH0_B="eth0"
fi

CON_B=$(ssh student@serverb "sudo nmcli -t -f NAME,DEVICE con show --active | grep \":$ETH0_B\" | cut -d: -f1")
if [ -z "$CON_B" ]; then
    CON_B="System eth0"
fi

ssh student@serverb "sudo sed -i '/^address1=/a address2=10.0.1.2/24' '/etc/NetworkManager/system-connections/$CON_B.nmconnection'"

echo "[root@serverb ~]# nmcli con reload"
history -s "nmcli con reload"
ssh student@serverb "sudo nmcli con reload"

echo "[root@serverb ~]# nmcli con up \"$CON_B\""
history -s "nmcli con up \"$CON_B\""
ssh student@serverb "sudo nmcli con up \"$CON_B\""

echo "[root@serverb ~]# ip -br addr show $ETH0_B"
history -s "ip -br addr show $ETH0_B"
ssh student@serverb "ip -br addr show $ETH0_B"

# Ping servera from serverb
echo "[root@serverb ~]# ping -c3 10.0.1.1"
history -s "ping -c3 10.0.1.1"
ssh student@serverb "ping -c3 10.0.1.1"

# Exit serverb
echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# Step 5: Test ping to serverb from servera via workstation
echo "[student@workstation ~]$ ssh student@servera ping -c3 10.0.1.2"
history -s "ssh student@servera ping -c3 10.0.1.2"
ssh student@servera ping -c3 10.0.1.2

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish net-edit"
history -s "lab finish net-edit"
lab finish net-edit

history -w