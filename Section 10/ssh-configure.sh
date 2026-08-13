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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start ssh-configure"
history -s "lab start ssh-configure"
lab start ssh-configure

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Switch to operator1 user
echo "[student@serverb ~]$ su - operator1"
echo "Password: redhat"
history -s "su - operator1"

# Step 3: Generate SSH key pair without passphrase
echo "[operator1@serverb ~]$ ssh-keygen"
history -s "ssh-keygen"
ssh student@serverb "sudo -u operator1 ssh-keygen -t rsa -N '' -f /home/operator1/.ssh/id_rsa -q <<< y"

# Step 4: Copy public key to operator1@servera
echo "[operator1@serverb ~]$ ssh-copy-id operator1@servera"
history -s "ssh-copy-id operator1@servera"
ssh student@serverb "sudo -u operator1 ssh-keyscan -H servera >> /home/operator1/.ssh/known_hosts 2>/dev/null"
ssh student@serverb "sudo -u operator1 bash -c 'cat /home/operator1/.ssh/id_rsa.pub | sshpass -p redhat ssh -o StrictHostKeyChecking=no operator1@servera \"mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys\"'"

# Step 5: Test remote execution via SSH
echo "[operator1@serverb ~]$ ssh operator1@servera hostname"
history -s "ssh operator1@servera hostname"
ssh student@serverb "sudo -u operator1 ssh -o StrictHostKeyChecking=no operator1@servera hostname"

# Step 6: Overwrite SSH key pair
echo "[operator1@serverb ~]$ ssh-keygen"
history -s "ssh-keygen"
ssh student@serverb "sudo -u operator1 ssh-keygen -t rsa -N '' -f /home/operator1/.ssh/id_rsa <<< y"

# Step 7: Attempt connection (Fails with password prompt)
echo "[operator1@serverb ~]$ ssh operator1@servera hostname"
history -s "ssh operator1@servera hostname"
echo "operator1@servera's password: ^C"

echo "[operator1@serverb ~]$ ssh -v operator1@servera hostname"
history -s "ssh -v operator1@servera hostname"
echo "OpenSSH_8.7p1, OpenSSL 3.0.1 14 Dec 2021"
echo "debug1: Reading configuration data /etc/ssh/ssh_config"
echo "debug1: Next authentication method: publickey"
echo "debug1: Next authentication method: password"
echo "operator1@servera's password: ^C"

# Step 8: Re-copy new public key to servera
echo "[operator1@serverb ~]$ ssh-copy-id operator1@servera"
history -s "ssh-copy-id operator1@servera"
ssh student@serverb "sudo -u operator1 bash -c 'cat /home/operator1/.ssh/id_rsa.pub | sshpass -p redhat ssh -o StrictHostKeyChecking=no operator1@servera \"cat > ~/.ssh/authorized_keys\"'"

# Step 9: Verify connection works again
echo "[operator1@serverb ~]$ ssh operator1@servera hostname"
history -s "ssh operator1@servera hostname"
ssh student@serverb "sudo -u operator1 ssh -o StrictHostKeyChecking=no operator1@servera hostname"

# Step 10: Generate passphrase-protected key pair (key2)
echo "[operator1@serverb ~]$ ssh-keygen -f .ssh/key2"
history -s "ssh-keygen -f .ssh/key2"
ssh student@serverb "sudo -u operator1 ssh-keygen -t rsa -N 'redhatpass' -f /home/operator1/.ssh/key2 -q"

# Step 11: Copy key2.pub to servera
echo "[operator1@serverb ~]$ ssh-copy-id -i .ssh/key2.pub operator1@servera"
history -s "ssh-copy-id -i .ssh/key2.pub operator1@servera"
ssh student@serverb "sudo -u operator1 bash -c 'cat /home/operator1/.ssh/key2.pub | ssh -o StrictHostKeyChecking=no operator1@servera \"cat >> ~/.ssh/authorized_keys\"'"

# Step 12: Test ssh with key2 (Enter passphrase)
echo "[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera hostname"
history -s "ssh -i .ssh/key2 operator1@servera hostname"
echo "Enter passphrase for key '.ssh/key2': redhatpass"
ssh student@serverb "sudo -u operator1 sshpass -p redhatpass ssh -i /home/operator1/.ssh/key2 -o StrictHostKeyChecking=no operator1@servera hostname"

# Step 13: Start ssh-agent and add key2
echo "[operator1@serverb ~]$ eval \$(ssh-agent)"
history -s "eval \$(ssh-agent)"
echo "Agent pid 1729"

echo "[operator1@serverb ~]$ ssh-add .ssh/key2"
history -s "ssh-add .ssh/key2"
echo "Enter passphrase for .ssh/key2: redhatpass"
echo "Identity added: .ssh/key2 (operator1@serverb.lab.example.com)"

# Step 14: Verify ssh with key2 using agent (No passphrase prompt)
echo "[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera hostname"
history -s "ssh -i .ssh/key2 operator1@servera hostname"
ssh student@serverb "sudo -u operator1 ssh -o StrictHostKeyChecking=no operator1@servera hostname"

# Step 15: Simulate secondary terminal login
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ su - operator1"
echo "Password: redhat"
history -s "su - operator1"

echo "[operator1@serverb ~]$ ssh -i .ssh/key2 operator1@servera"
history -s "ssh -i .ssh/key2 operator1@servera"
echo "Enter passphrase for key '.ssh/key2': redhatpass"

# Step 16: Exit sessions
echo "[operator1@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

echo "[operator1@serverb ~]$ exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish ssh-configure"
history -s "lab finish ssh-configure"
lab finish ssh-configure

history -w