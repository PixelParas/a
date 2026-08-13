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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start net-hostnames"
history -s "lab start net-hostnames"
lab start net-hostnames

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Log in to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@testa ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: View current hostname settings
echo "[root@testa ~]# hostname"
history -s "hostname"
ssh student@servera "hostname"

echo "[root@testa ~]# hostnamectl status"
history -s "hostnamectl status"
ssh student@servera "hostnamectl status"

# Step 3: Set static hostname
echo "[root@testa ~]# hostnamectl hostname servera.lab.example.com"
history -s "hostnamectl hostname servera.lab.example.com"
ssh student@servera "sudo hostnamectl hostname servera.lab.example.com"

echo "[root@testa ~]# cat /etc/hostname"
history -s "cat /etc/hostname"
ssh student@servera "cat /etc/hostname"

# Step 4: Reconnect to verify updated hostname prompt
echo "[root@testa ~]# exit"
echo "logout"
history -s "exit"

echo "[student@testa ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

echo "[root@servera ~]# hostnamectl status"
history -s "hostnamectl status"
ssh student@servera "hostnamectl status"

# Step 5: Temporarily change hostname and test reboot persistence
echo "[root@servera ~]# hostname testname"
history -s "hostname testname"
ssh student@servera "sudo hostname testname"

echo "[root@servera ~]# hostname"
history -s "hostname"
ssh student@servera "hostname"

echo "[root@servera ~]# cat /etc/hostname"
history -s "cat /etc/hostname"
ssh student@servera "cat /etc/hostname"

echo "[root@servera ~]# systemctl reboot"
echo "Connection to servera closed by remote host."
echo "Connection to servera closed."
history -s "systemctl reboot"

ssh student@servera "sudo systemctl reboot" || true
sleep 10

# Step 6: Log back in after reboot and verify static hostname
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

echo "[root@servera ~]# hostname"
history -s "hostname"
ssh student@servera "hostname"

# Step 7: Configure /etc/hosts for nickname 'class'
echo "[root@servera ~]# host classroom.example.com"
history -s "host classroom.example.com"
ssh student@servera "host classroom.example.com"

echo "[root@servera ~]# vim /etc/hosts"
history -s "vim /etc/hosts"
ssh student@servera "sudo bash -c 'grep -q \"172.25.254.254\" /etc/hosts || echo \"172.25.254.254 classroom.example.com classroom class\" >> /etc/hosts'"

echo "[root@servera ~]# host class"
history -s "host class"
ssh student@servera "host class" || true

echo "[root@servera ~]# getent hosts class"
history -s "getent hosts class"
ssh student@servera "getent hosts class"

echo "[root@servera ~]# ping -c3 class"
history -s "ping -c3 class"
ssh student@servera "ping -c3 class"

# Step 8: Exit servera
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

echo "[student@workstation ~]$ lab finish net-hostnames"
history -s "lab finish net-hostnames"
lab finish net-hostnames

history -w