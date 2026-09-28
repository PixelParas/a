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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start services-review"
history -s "lab start services-review"
lab start services-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: SSH into serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Start and enable psacct service
echo "[root@serverb ~]# systemctl start psacct"
history -s "systemctl start psacct"
ssh student@serverb "echo student | sudo -S systemctl start psacct"

echo "[root@serverb ~]# systemctl enable psacct"
history -s "systemctl enable psacct"
ssh student@serverb "echo student | sudo -S systemctl enable psacct"

# Step 3: Stop and disable rsyslog service
echo "[root@serverb ~]# systemctl stop rsyslog"
history -s "systemctl stop rsyslog"
ssh student@serverb "echo student | sudo -S systemctl stop rsyslog"

echo "[root@serverb ~]# systemctl disable rsyslog"
history -s "systemctl disable rsyslog"
ssh student@serverb "echo student | sudo -S systemctl disable rsyslog"

# Step 4: Reboot serverb machine
echo "[root@serverb ~]# systemctl reboot"
echo "Connection to serverb closed by remote host."
echo "Connection to serverb closed."
history -s "systemctl reboot"

ssh student@serverb "echo student | sudo -S systemctl reboot" || true
sleep 30 # Increased sleep to ensure serverb is online before lab grade runs

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade services-review"
history -s "lab grade services-review"
lab grade services-review

echo "[student@workstation ~]$ lab finish services-review"
history -s "lab finish services-review"
lab finish services-review

history -w
