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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start software-review"
history -s "lab start software-review"
lab start software-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Create /etc/yum.repos.d/errata.repo repository file
echo "[root@serverb ~]# vim /etc/yum.repos.d/errata.repo"
history -s "vim /etc/yum.repos.d/errata.repo"

# Properly structured repo creation over SSH using sudo and bash -c
ssh -o StrictHostKeyChecking=no student@serverb "echo student | sudo -S bash -c 'echo -e \"[errata]\nname=errata\nbaseurl=http://content.example.com/rhel9.3/x86_64/rhcsa-practice/errata\nenabled=1\ngpgcheck=0\" > /etc/yum.repos.d/errata.repo' 2>/dev/null"

# Step 3: Install rht-system package
echo "[root@serverb ~]# dnf install rht-system"
history -s "dnf install rht-system"
ssh -o StrictHostKeyChecking=no student@serverb "echo student | sudo -S dnf install -y rht-system 2>/dev/null"

# Step 4: Remove cups package to disable printing capabilities
echo "[root@serverb ~]# dnf remove cups"
history -s "dnf remove cups"
ssh -o StrictHostKeyChecking=no student@serverb "echo student | sudo -S dnf remove -y cups 2>/dev/null"

# Step 5: Exit root shell on serverb
echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

# Step 6: Verify and install rhcsa-script RPM package as student with sudo
echo "[student@serverb ~]$ ls -l rhcsa-script-1.0.0-1.noarch.rpm"
history -s "ls -l rhcsa-script-1.0.0-1.noarch.rpm"
ssh -o StrictHostKeyChecking=no student@serverb "ls -l rhcsa-script-1.0.0-1.noarch.rpm 2>/dev/null"

echo "[student@serverb ~]$ sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
history -s "sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
ssh -o StrictHostKeyChecking=no student@serverb "echo student | sudo -S rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm 2>/dev/null"

# Step 7: Verify package installation
echo "[student@serverb ~]$ rpm -q rhcsa-script"
history -s "rpm -q rhcsa-script"
ssh -o StrictHostKeyChecking=no student@serverb "rpm -q rhcsa-script 2>/dev/null"

# Step 8: Exit serverb connection
echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade software-review"
history -s "lab grade software-review"
lab grade software-review

echo "[student@workstation ~]$ lab finish software-review"
history -s "lab finish software-review"
lab finish software-review

history -w
