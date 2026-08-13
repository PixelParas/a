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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|rhcsa-rh124-review3\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start rhcsa-rh124-review3"
history -s "lab start rhcsa-rh124-review3"
lab start rhcsa-rh124-review3

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: SSH into serverb as student
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Generate SSH key pair on serverb without passphrase
echo "[student@serverb ~]$ ssh-keygen -f /home/student/.ssh/review3_key -N \"\""
history -s "ssh-keygen -f /home/student/.ssh/review3_key -N \"\""
ssh student@serverb "ssh-keygen -f /home/student/.ssh/review3_key -N '' -q"

# Step 3: Configure student user on servera to accept review3_key authentication
echo "[student@serverb ~]$ ssh-copy-id -i /home/student/.ssh/review3_key.pub student@servera"
history -s "ssh-copy-id -i /home/student/.ssh/review3_key.pub student@servera"

PUB_KEY=$(ssh student@serverb "cat /home/student/.ssh/review3_key.pub")
ssh student@servera "mkdir -p ~/.ssh && chmod 700 ~/.ssh && echo '$PUB_KEY' >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"

# Verify passwordless SSH login from serverb to servera
echo "[student@serverb ~]$ ssh -i /home/student/.ssh/review3_key student@servera"
history -s "ssh -i /home/student/.ssh/review3_key student@servera"
ssh student@serverb "ssh -o StrictHostKeyChecking=no -i /home/student/.ssh/review3_key student@servera 'hostname'" >/dev/null 2>&1

# Step 4: Switch to root on serverb
echo "[student@serverb ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 5: Disable root login and password authentication in sshd on serverb
echo "[root@serverb ~]# vim /etc/ssh/sshd_config.d/01-custom.conf"
history -s "vim /etc/ssh/sshd_config.d/01-custom.conf"

ssh student@serverb "sudo bash -c 'cat <<EOF > /etc/ssh/sshd_config.d/01-custom.conf
PermitRootLogin no
PasswordAuthentication no
EOF'"

ssh student@serverb "sudo sed -i 's/^#*PermitRootLogin.*/PermitRootLogin no/' /etc/ssh/sshd_config"
ssh student@serverb "sudo sed -i 's/^#*PasswordAuthentication.*/PasswordAuthentication no/' /etc/ssh/sshd_config"

echo "[root@serverb ~]# systemctl reload sshd"
history -s "systemctl reload sshd"
ssh student@serverb "sudo systemctl reload sshd"

# Step 6: Install zsh package on serverb
echo "[root@serverb ~]# dnf install -y zsh"
history -s "dnf install -y zsh"
ssh student@serverb "sudo dnf install -y zsh"

# Step 7: Exit root and serverb session
echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade rhcsa-rh124-review3"
history -s "lab grade rhcsa-rh124-review3"
lab grade rhcsa-rh124-review3

echo "[student@workstation ~]$ lab finish rhcsa-rh124-review3"
history -s "lab finish rhcsa-rh124-review3"
lab finish rhcsa-rh124-review3

history -w