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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start net-configure"
history -s "lab start net-configure"
lab start net-configure

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Determine target interface and original connection name dynamically
ETH0=$(ssh student@servera "ip -o link show | grep -i '52:54:00:00:fa:0a' | awk -F': ' '{print \$2}' | head -n1")
if [ -z "$ETH0" ]; then
    ETH0=$(ssh student@servera "ip -br link | grep -v 'lo' | awk '{print \$1}' | head -n1")
fi

ORIG_CON=$(ssh student@servera "sudo nmcli -t -f NAME,DEVICE con show --active | grep \":$ETH0\" | cut -d: -f1")
if [ -z "$ORIG_CON" ]; then
    ORIG_CON="System eth0"
fi

# Step 2: Inspect network interfaces and connection status
echo "[root@servera ~]# ip link"
history -s "ip link"
ssh student@servera "sudo ip link"

echo "[root@servera ~]# nmcli con show --active"
history -s "nmcli con show --active"
ssh student@servera "sudo nmcli con show --active"

echo "[root@servera ~]# nmcli con show \"$ORIG_CON\""
history -s "nmcli con show \"$ORIG_CON\""
ssh student@servera "sudo nmcli con show \"$ORIG_CON\""

echo "[root@servera ~]# nmcli dev status"
history -s "nmcli dev status"
ssh student@servera "sudo nmcli dev status"

echo "[root@servera ~]# nmcli dev show $ETH0"
history -s "nmcli dev show $ETH0"
ssh student@servera "sudo nmcli dev show $ETH0"

# Step 3: Create a new static connection
echo "[root@servera ~]# nmcli con add con-name static-addr ifname $ETH0 type ethernet ipv4.method manual ipv4.dns 172.25.250.220 ipv4.addresses 172.25.250.10/24 ipv4.gateway 172.25.250.254"
history -s "nmcli con add con-name static-addr ifname $ETH0 type ethernet ipv4.method manual ipv4.dns 172.25.250.220 ipv4.addresses 172.25.250.10/24 ipv4.gateway 172.25.250.254"
ssh student@servera "sudo nmcli con add con-name static-addr ifname $ETH0 type ethernet ipv4.method manual ipv4.dns 172.25.250.220 ipv4.addresses 172.25.250.10/24 ipv4.gateway 172.25.250.254"

# Step 4: Display and activate static connection
echo "[root@servera ~]# nmcli con show"
history -s "nmcli con show"
ssh student@servera "sudo nmcli con show"

echo "[root@servera ~]# nmcli con show --active"
history -s "nmcli con show --active"
ssh student@servera "sudo nmcli con show --active"

echo "[root@servera ~]# nmcli con up static-addr"
history -s "nmcli con up static-addr"
ssh student@servera "sudo nmcli con up static-addr"

echo "[root@servera ~]# nmcli con show --active"
history -s "nmcli con show --active"
ssh student@servera "sudo nmcli con show --active"

# Step 5: Disable autoconnect on original connection
echo "[root@servera ~]# nmcli con mod \"$ORIG_CON\" connection.autoconnect no"
history -s "nmcli con mod \"$ORIG_CON\" connection.autoconnect no"
ssh student@servera "sudo nmcli con mod \"$ORIG_CON\" connection.autoconnect no"

# Step 6: Reboot system and reconnect
echo "[root@servera ~]# systemctl reboot"
echo "Connection to servera closed by remote host."
echo "Connection to servera closed."
history -s "systemctl reboot"

ssh student@servera "sudo systemctl reboot" || true
sleep 10

# Step 7: Verify active configuration after reboot
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ nmcli con show --active"
history -s "nmcli con show --active"
ssh student@servera "nmcli con show --active"

echo "[student@servera ~]$ ip -br addr show $ETH0"
history -s "ip -br addr show $ETH0"
ssh student@servera "ip -br addr show $ETH0"

echo "[student@servera ~]$ ip route"
history -s "ip route"
ssh student@servera "ip route"

echo "[student@servera ~]$ ping -c3 172.25.250.220"
history -s "ping -c3 172.25.250.220"
ssh student@servera "ping -c3 172.25.250.220"

# Step 8: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish net-configure"
history -s "lab finish net-configure"
lab finish net-configure

history -w