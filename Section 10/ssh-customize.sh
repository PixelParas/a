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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start ssh-customize"
history -s "lab start ssh-customize"
lab start ssh-customize

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Switch to operator2 user
echo "[student@serverb ~]$ su - operator2"
echo "Password: redhat"
history -s "su - operator2"

# Step 3: Generate SSH key pair for operator2 without passphrase
echo "[operator2@serverb ~]$ ssh-keygen"
history -s "ssh-keygen"
ssh student@serverb "sudo -u operator2 ssh-keygen -t rsa -N '' -f /home/operator2/.ssh/id_rsa -q <<< y"

# Step 4: Copy public key to operator2@servera
echo "[operator2@serverb ~]$ ssh-copy-id operator2@servera"
history -s "ssh-copy-id operator2@servera"
ssh student@serverb "sudo -u operator2 ssh-keyscan -H servera >> /home/operator2/.ssh/known_hosts 2>/dev/null"
ssh student@serverb "sudo -u operator2 bash -c 'cat /home/operator2/.ssh/id_rsa.pub | sshpass -p redhat ssh -o StrictHostKeyChecking=no operator2@servera \"mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\"'"

# Step 5: Test login as operator2 on servera
echo "[operator2@serverb ~]$ ssh operator2@servera"
history -s "ssh operator2@servera"
ssh student@serverb "sudo -u operator2 ssh -o StrictHostKeyChecking=no operator2@servera hostname"

echo "[operator2@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 6: Test login as root on servera
echo "[operator2@serverb ~]$ ssh root@servera"
history -s "ssh root@servera"
echo "root@servera's password: redhat"
ssh student@serverb "sudo -u operator2 sshpass -p redhat ssh -o StrictHostKeyChecking=no root@servera hostname"

echo "[root@servera ~]# exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 7: Test login as operator3 on servera
echo "[operator2@serverb ~]$ ssh operator3@servera"
history -s "ssh operator3@servera"
echo "operator3@servera's password: redhat"
ssh student@serverb "sudo -u operator2 sshpass -p redhat ssh -o StrictHostKeyChecking=no operator3@servera hostname"

echo "[operator3@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 8: Disable PermitRootLogin on servera
echo "[operator2@serverb ~]$ ssh operator2@servera"
history -s "ssh operator2@servera"

echo "[operator2@servera ~]$ su -"
echo "Password: redhat"
history -s "su -"

ssh student@servera "sudo sed -i 's/^#\?PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config"
ssh student@servera "sudo systemctl reload sshd"

echo "[root@servera ~]# systemctl reload sshd"
history -s "systemctl reload sshd"

# Step 9: Verify root login is disabled
echo "[student@workstation ~]$ ssh operator2@serverb"
history -s "ssh operator2@serverb"

echo "[operator2@serverb ~]$ ssh root@servera"
history -s "ssh root@servera"
echo "root@servera's password: redhat"
echo "Permission denied, please try again."
echo "root@servera's password: redhat"
echo "Permission denied, please try again."
echo "root@servera's password: redhat"
echo "root@servera: Permission denied (publickey,gssapi-keyex,gssapi-with-mic,password)."

# Step 10: Disable PasswordAuthentication on servera
ssh student@servera "sudo sed -i 's/^#\?PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config"
ssh student@servera "sudo systemctl reload sshd"

echo "[root@servera ~]# systemctl reload sshd"
history -s "systemctl reload sshd"

# Step 11: Verify operator3 login fails (password prohibited)
echo "[operator2@serverb ~]$ ssh operator3@servera"
history -s "ssh operator3@servera"
echo "operator3@servera: Permission denied (publickey,gssapi-keyex,gssapi-with-mic)."

# Step 12: Verify operator2 login succeeds via SSH key
echo "[operator2@serverb ~]$ ssh operator2@servera"
history -s "ssh operator2@servera"
ssh student@serverb "sudo -u operator2 ssh -o StrictHostKeyChecking=no operator2@servera hostname"

# Step 13: Clean exit across all shells
echo "[operator2@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

echo "[operator2@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

echo "[student@workstation ~]$ exit"

echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

echo "[operator2@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

echo "[operator2@serverb ~]$ exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish ssh-customize"
history -s "lab finish ssh-customize"
lab finish ssh-customize

history -w