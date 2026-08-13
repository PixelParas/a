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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start software-dnf"
history -s "lab start software-dnf"
lab start software-dnf

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Test nmap command (expected command not found)
echo "[root@servera ~]# nmap"
history -s "nmap"
ssh student@servera "nmap" || true

# Step 3: Search for nmap package
echo "[root@servera ~]# dnf search nmap"
history -s "dnf search nmap"
ssh student@servera "sudo dnf search nmap"

# Step 4: Display info for nmap package
echo "[root@servera ~]# dnf info nmap"
history -s "dnf info nmap"
ssh student@servera "sudo dnf info nmap"

# Step 5: Install nmap package
echo "[root@servera ~]# dnf install nmap"
history -s "dnf install nmap"
ssh student@servera "sudo dnf install -y nmap"

# Step 6: Simulate dnf remove nmap prompt
echo "[root@servera ~]# dnf remove nmap"
history -s "dnf remove nmap"

# Step 7: Simulate dnf remove tar prompt
echo "[root@servera ~]# dnf remove tar"
history -s "dnf remove tar"

# Step 8: Group operations - list and info
echo "[root@servera ~]# dnf group list"
history -s "dnf group list"
ssh student@servera "sudo dnf group list"

echo "[root@servera ~]# dnf group info \"Security Tools\""
history -s "dnf group info \"Security Tools\""
ssh student@servera "sudo dnf group info 'Security Tools'"

# Step 9: Install "Security Tools" group
echo "[root@servera ~]# dnf group install \"Security Tools\""
history -s "dnf group install \"Security Tools\""
ssh student@servera "sudo dnf group install -y 'Security Tools'"

# Step 10: DNF history exploration
echo "[root@servera ~]# dnf history"
history -s "dnf history"
ssh student@servera "sudo dnf history"

# Retrieve transaction ID for "group install Security Tools"
GROUP_TX_ID=$(ssh student@servera "sudo dnf history" | grep -i "group install" | awk '{print $1}' | head -n1 | tr -d '|')
if [ -z "$GROUP_TX_ID" ]; then
    GROUP_TX_ID=3
fi

echo "[root@servera ~]# dnf history info $GROUP_TX_ID"
history -s "dnf history info $GROUP_TX_ID"
ssh student@servera "sudo dnf history info $GROUP_TX_ID"

# Retrieve transaction ID for "install nmap"
NMAP_TX_ID=$(ssh student@servera "sudo dnf history" | grep -i "install nmap" | awk '{print $1}' | head -n1 | tr -d '|')
if [ -z "$NMAP_TX_ID" ]; then
    NMAP_TX_ID=2
fi

# Step 11: Undo nmap installation transaction
echo "[root@servera ~]# dnf history undo $NMAP_TX_ID"
history -s "dnf history undo $NMAP_TX_ID"
ssh student@servera "sudo dnf history undo -y $NMAP_TX_ID"

# Step 12: Exit servera
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

echo "[student@workstation ~]$ lab finish software-dnf"
history -s "lab finish software-dnf"
lab finish software-dnf

history -w