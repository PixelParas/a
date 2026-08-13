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
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Create /etc/yum.repos.d/errata.repo repository file
echo "[root@serverb ~]# vim /etc/yum.repos.d/errata.repo"
history -s "vim /etc/yum.repos.d/errata.repo"
ssh student@serverb "sudo bash -c 'cat <<EOF > /etc/yum.repos.d/errata.repo
[errata]
name=errata
baseurl=http://content.example.com/rhel9.3/x86_64/rhcsa-practice/errata
enabled=1
gpgcheck=0
EOF'"

# Step 3: Install rht-system package
echo "[root@serverb ~]# dnf install rht-system"
history -s "dnf install rht-system"
ssh student@serverb "sudo dnf install -y rht-system"

# Step 4: Remove cups package to disable printing capabilities
echo "[root@serverb ~]# dnf remove cups"
history -s "dnf remove cups"
ssh student@serverb "sudo dnf remove -y cups"

# Step 5: Exit root shell on serverb
echo "[root@serverb ~]# exit"
echo "logout"
history -s "exit"

# Step 6: Verify and install rhcsa-script RPM package as student with sudo
echo "[student@serverb ~]$ ls -l rhcsa-script-1.0.0-1.noarch.rpm"
history -s "ls -l rhcsa-script-1.0.0-1.noarch.rpm"
ssh student@serverb "ls -l rhcsa-script-1.0.0-1.noarch.rpm"

echo "[student@serverb ~]$ sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
echo "[sudo] password for student: student"
history -s "sudo rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"
ssh student@serverb "echo student | sudo -S rpm -ivh rhcsa-script-1.0.0-1.noarch.rpm"

# Step 7: Verify package installation
echo "[student@serverb ~]$ rpm -q rhcsa-script"
history -s "rpm -q rhcsa-script"
ssh student@serverb "rpm -q rhcsa-script"

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