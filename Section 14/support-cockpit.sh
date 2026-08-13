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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start support-cockpit"
history -s "lab start support-cockpit"
lab start support-cockpit

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Enable and start cockpit service
echo "[student@servera ~]$ sudo systemctl enable --now cockpit.socket"
echo "[sudo] password for student: student"
history -s "sudo systemctl enable --now cockpit.socket"
ssh student@servera "echo student | sudo -S systemctl enable --now cockpit.socket"

# Step 3: Execute system actions corresponding to Web Console steps on servera
echo "[student@servera ~]$ id"
history -s "id"
ssh student@servera "id"

# Add secondary IP address (172.25.250.99/24) to eth0
ssh student@servera "sudo nmcli connection modify eth0 +ipv4.addresses 172.25.250.99/24 && sudo nmcli connection up eth0"

# Create user manager1 with password redh@t!23
ssh student@servera "sudo useradd -c 'manager1' manager1 && echo 'manager1:redh@t!23' | sudo chpasswd"

# Verify manager1 group membership
echo "[student@servera ~]$ id manager1"
history -s "id manager1"
ssh student@servera "id manager1"

# Add manager1 to wheel group
echo "[student@servera ~]$ sudo usermod -aG wheel manager1"
history -s "sudo usermod -aG wheel manager1"
ssh student@servera "echo student | sudo -S usermod -aG wheel manager1"

# Verify updated manager1 group membership
echo "[student@servera ~]$ id manager1"
history -s "id manager1"
ssh student@servera "id manager1"

# Enable and start psacct service
ssh student@servera "sudo systemctl enable --now psacct"

# Step 4: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish support-cockpit"
history -s "lab finish support-cockpit"
lab finish support-cockpit

history -w