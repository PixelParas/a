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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start services-identify"
history -s "lab start services-identify"
lab start services-identify

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: List installed service units
echo "[student@servera ~]$ systemctl list-units --type=service"
history -s "systemctl list-units --type=service"
ssh student@servera "systemctl list-units --type=service --no-pager"

# Step 3: List socket units
echo "[student@servera ~]$ systemctl list-units --type=socket --all"
history -s "systemctl list-units --type=socket --all"
ssh student@servera "systemctl list-units --type=socket --all --no-pager"

# Step 4: Check status of chronyd service
echo "[student@servera ~]$ systemctl status chronyd"
history -s "systemctl status chronyd"
ssh student@servera "systemctl status chronyd --no-pager"

# Step 5: Verify chronyd process using its PID
echo "[student@servera ~]$ ps -p \$(pgrep -o chronyd)"
history -s "ps -p \$(pgrep -o chronyd)"
ssh student@servera "ps -p \$(pgrep -o chronyd)"

# Step 6: Check enabled and active state of sshd service
echo "[student@servera ~]$ systemctl is-enabled sshd"
history -s "systemctl is-enabled sshd"
ssh student@servera "systemctl is-enabled sshd"

echo "[student@servera ~]$ systemctl is-active sshd"
history -s "systemctl is-active sshd"
ssh student@servera "systemctl is-active sshd"

echo "[student@servera ~]$ systemctl status sshd"
history -s "systemctl status sshd"
ssh student@servera "systemctl status sshd --no-pager"

# Step 7: List state of all service unit files
echo "[student@servera ~]$ systemctl list-unit-files --type=service"
history -s "systemctl list-unit-files --type=service"
ssh student@servera "systemctl list-unit-files --type=service --no-pager"

# Step 8: Exit servera session
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish services-identify"
history -s "lab finish services-identify"
lab finish services-identify

history -w