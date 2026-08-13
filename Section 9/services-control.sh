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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start services-control"
history -s "lab start services-control"
lab start services-control

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Restart and reload sshd service
echo "[root@servera ~]# systemctl status sshd"
history -s "systemctl status sshd"
ssh student@servera "sudo systemctl status sshd --no-pager"

echo "[root@servera ~]# systemctl restart sshd"
history -s "systemctl restart sshd"
ssh student@servera "sudo systemctl restart sshd"

echo "[root@servera ~]# systemctl status sshd"
history -s "systemctl status sshd"
ssh student@servera "sudo systemctl status sshd --no-pager"

echo "[root@servera ~]# systemctl reload sshd"
history -s "systemctl reload sshd"
ssh student@servera "sudo systemctl reload sshd"

echo "[root@servera ~]# systemctl status sshd"
history -s "systemctl status sshd"
ssh student@servera "sudo systemctl status sshd --no-pager"

# Step 3: Manage chronyd service (Stop & Check Enabled)
echo "[root@servera ~]# systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "sudo systemctl status chronyd --no-pager"

echo "[root@servera ~]# systemctl stop chronyd"
history -s "systemctl stop chronyd"
ssh student@servera "sudo systemctl stop chronyd"

echo "[root@servera ~]# systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "sudo systemctl status chronyd --no-pager"

echo "[root@servera ~]# systemctl is-enabled chronyd"
history -s "systemctl is-enabled chronyd"
ssh student@servera "sudo systemctl is-enabled chronyd"

# Simulate system reboot 1 (Re-enables active state for enabled service)
echo "[root@servera ~]# systemctl reboot"
echo "Connection to servera closed by remote host."
echo "Connection to servera closed."
history -s "systemctl reboot"
ssh student@servera "sudo systemctl start chronyd"

# Re-connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

echo "[root@servera ~]# systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "sudo systemctl status chronyd --no-pager"

# Step 4: Disable chronyd service
echo "[root@servera ~]# systemctl disable chronyd"
history -s "systemctl disable chronyd"
ssh student@servera "sudo systemctl disable chronyd"

echo "[root@servera ~]# systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "sudo systemctl status chronyd --no-pager"

# Simulate system reboot 2 (Leaves disabled service inactive)
echo "[root@servera ~]# systemctl reboot"
echo "Connection to servera closed by remote host."
echo "Connection to servera closed."
history -s "systemctl reboot"
ssh student@servera "sudo systemctl stop chronyd"

# Re-connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "systemctl status chronyd --no-pager"

# Step 5: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish services-control"
history -s "lab finish services-control"
lab finish services-control

history -w