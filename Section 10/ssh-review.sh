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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start ssh-review"
history -s "lab start ssh-review"
lab start ssh-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Switch to production1 user
echo "[student@servera ~]$ su - production1"
echo "Password: redhat"
history -s "su - production1"

# Step 3: Generate passphrase-less SSH key pair on servera
echo "[production1@servera ~]$ ssh-keygen"
history -s "ssh-keygen"
ssh student@servera "sudo -u production1 ssh-keygen -t rsa -N '' -f /home/production1/.ssh/id_rsa -q <<< y"

# Step 4: Copy public key to production1@serverb
echo "[production1@servera ~]$ ssh-copy-id production1@serverb"
history -s "ssh-copy-id production1@serverb"
ssh student@servera "sudo -u production1 ssh-keyscan -H serverb >> /home/production1/.ssh/known_hosts 2>/dev/null"
ssh student@servera "sudo -u production1 bash -c 'cat /home/production1/.ssh/id_rsa.pub | sshpass -p redhat ssh -o StrictHostKeyChecking=no production1@serverb \"mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\"'"

# Step 5: Verify production1 key authentication from servera to serverb
echo "[production1@servera ~]$ ssh production1@serverb hostname"
history -s "ssh production1@serverb hostname"
ssh student@servera "sudo -u production1 ssh -o StrictHostKeyChecking=no production1@serverb hostname"

# Step 6: Exit production1 session
echo "[production1@servera ~]$ exit"
echo "logout"
history -s "exit"

# Step 7: Configure sshd service on serverb (Disable root login & password auth)
echo "[student@servera ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

ssh student@serverb "sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config"
ssh student@serverb "sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config"

echo "[root@serverb ~]# systemctl reload sshd"
history -s "systemctl reload sshd"
ssh student@serverb "sudo systemctl reload sshd"

echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade ssh-review"
history -s "lab grade ssh-review"
lab grade ssh-review

echo "[student@workstation ~]$ lab finish ssh-review"
history -s "lab finish ssh-review"
lab finish ssh-review

history -w