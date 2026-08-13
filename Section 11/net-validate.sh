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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start net-validate"
history -s "lab start net-validate"
lab start net-validate

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Display interface link status and determine interface name
echo "[student@servera ~]$ ip link"
history -s "ip link"
ssh student@servera "ip link"

ENX=$(ssh student@servera "ip -o link show | grep -i '52:54:00:00:fa:0a' | awk -F': ' '{print \$2}' | head -n1")
if [ -z "$ENX" ]; then
    ENX=$(ssh student@servera "ip -br link | grep -v 'lo' | awk '{print \$1}' | head -n1")
fi

# Step 3: Display current IP address and netmask
echo "[student@servera ~]$ ip -br addr"
history -s "ip -br addr"
ssh student@servera "ip -br addr"

# Step 4: Display statistics for interface
echo "[student@servera ~]$ ip -s link show $ENX"
history -s "ip -s link show $ENX"
ssh student@servera "ip -s link show $ENX"

# Step 5: Display route information
echo "[student@servera ~]$ ip route"
history -s "ip route"
ssh student@servera "ip route"

# Step 6: Verify router is accessible
echo "[student@servera ~]$ ping -c3 172.25.250.254"
history -s "ping -c3 172.25.250.254"
ssh student@servera "ping -c3 172.25.250.254"

# Step 7: Trace route to classroom.example.com
echo "[student@servera ~]$ tracepath classroom.example.com"
history -s "tracepath classroom.example.com"
ssh student@servera "tracepath classroom.example.com"

# Step 8: Display listening TCP sockets
echo "[student@servera ~]$ ss -lt"
history -s "ss -lt"
ssh student@servera "ss -lt"

# Step 9: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish net-validate"
history -s "lab finish net-validate"
lab finish net-validate

history -w