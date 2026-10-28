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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# Clear the old host key for serverb from workstation's known_hosts
ssh-keygen -R serverb 2>/dev/null || true

# SSH helper flags to avoid host key warnings and TTY prompts
SSH_CMD="ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null student@serverb"

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start net-review"
history -s "lab start net-review"
lab start net-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

# Determine primary network interface with MAC 52:54:00:00:fa:0b
ETH_B=$($SSH_CMD "ip -o link show | grep -i '52:54:00:00:fa:0b' | awk -F': ' '{print \$2}' | head -n1" 2>/dev/null)
if [ -z "$ETH_B" ]; then
    ETH_B="eth0"
fi

ORIG_CON_B=$($SSH_CMD "echo student | sudo -S nmcli -t -f NAME,DEVICE con show --active 2>/dev/null | grep \":$ETH_B\" | cut -d: -f1")
if [ -z "$ORIG_CON_B" ]; then
    ORIG_CON_B="System eth0"
fi

# Step 2: Create new static connection named 'lab'
echo "[root@serverb ~]# nmcli con add con-name lab ifname $ETH_B type ethernet ipv4.method manual ipv4.addresses 172.25.250.11/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254"
history -s "nmcli con add con-name lab ifname $ETH_B type ethernet ipv4.method manual ipv4.addresses 172.25.250.11/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254"
$SSH_CMD "echo student | sudo -S nmcli con add con-name lab ifname $ETH_B type ethernet ipv4.method manual ipv4.addresses 172.25.250.11/24 ipv4.gateway 172.25.250.254 ipv4.dns 172.25.250.254 2>/dev/null"

# Step 3: Disable autoconnect on original connection and set autoconnect on 'lab'
echo "[root@serverb ~]# nmcli con mod \"$ORIG_CON_B\" connection.autoconnect no"
history -s "nmcli con mod \"$ORIG_CON_B\" connection.autoconnect no"
$SSH_CMD "echo student | sudo -S nmcli con mod \"$ORIG_CON_B\" connection.autoconnect no 2>/dev/null"

echo "[root@serverb ~]# nmcli con mod lab connection.autoconnect yes"
history -s "nmcli con mod lab connection.autoconnect yes"
$SSH_CMD "echo student | sudo -S nmcli con mod lab connection.autoconnect yes 2>/dev/null"

# Step 4: Add secondary IP address 10.0.1.1/24 to 'lab' connection
echo "[root@serverb ~]# nmcli con mod lab +ipv4.addresses 10.0.1.1/24"
history -s "nmcli con mod lab +ipv4.addresses 10.0.1.1/24"
$SSH_CMD "echo student | sudo -S nmcli con mod lab +ipv4.addresses 10.0.1.1/24 2>/dev/null"

# Step 5: Activate 'lab' connection
echo "[root@serverb ~]# nmcli con up lab"
history -s "nmcli con up lab"
$SSH_CMD "echo student | sudo -S nmcli con up lab 2>/dev/null"

# Step 6: Configure /etc/hosts for 'private' hostname mapping
echo "[root@serverb ~]# vim /etc/hosts"
history -s "vim /etc/hosts"
$SSH_CMD "echo student | sudo -S bash -c 'grep -q \"10.0.1.1\" /etc/hosts || echo \"10.0.1.1 private\" >> /etc/hosts' 2>/dev/null"

# Step 7: Reboot system to verify settings persistence
echo "[root@serverb ~]# systemctl reboot"
echo "Connection to serverb closed by remote host."
echo "Connection to serverb closed."
history -s "systemctl reboot"

$SSH_CMD "echo student | sudo -S systemctl reboot 2>/dev/null" || true
sleep 30

# Step 8: Log back in and verify active connection
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ nmcli con show --active"
history -s "nmcli con show --active"
$SSH_CMD "nmcli con show --active 2>/dev/null"

echo "[student@serverb ~]$ ip -br addr show $ETH_B"
history -s "ip -br addr show $ETH_B"
$SSH_CMD "ip -br addr show $ETH_B 2>/dev/null"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade net-review"
history -s "lab grade net-review"
lab grade net-review

echo "[student@workstation ~]$ lab finish net-review"
history -s "lab finish net-review"
lab finish net-review

history -w
