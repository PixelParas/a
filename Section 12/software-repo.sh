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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start software-repo"
history -s "lab start software-repo"
lab start software-repo

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
echo "[sudo] password for student: student"
history -s "sudo -i"

# Step 2: Add custom packages repository using dnf config-manager
echo "[root@servera ~]# dnf config-manager --add-repo \"http://content.example.com/rhel9.3/x86_64/rhcsa-practice/rht\""
history -s "dnf config-manager --add-repo \"http://content.example.com/rhel9.3/x86_64/rhcsa-practice/rht\""
ssh student@servera "sudo dnf config-manager --add-repo \"http://content.example.com/rhel9.3/x86_64/rhcsa-practice/rht\""

# Step 3: Configure gpgcheck=0 in the newly created repo file
REPO_FILE="/etc/yum.repos.d/content.example.com_rhel9.3_x86_64_rhcsa-practice_rht.repo"
ssh student@servera "sudo bash -c 'grep -q \"gpgcheck=\" $REPO_FILE 2>/dev/null && sed -i \"s/gpgcheck=.*/gpgcheck=0/\" $REPO_FILE || echo \"gpgcheck=0\" >> $REPO_FILE'"

# Step 4: Create the errata.repo repository configuration file
echo "[root@servera ~]# vim /etc/yum.repos.d/errata.repo"
history -s "vim /etc/yum.repos.d/errata.repo"
ssh student@servera "sudo bash -c 'cat <<EOF > /etc/yum.repos.d/errata.repo
[rht-updates]
name=rht updates
baseurl=http://content.example.com/rhel9.3/x86_64/rhcsa-practice/errata
enabled=1
gpgcheck=0
EOF'"

# Step 5: List all repositories
echo "[root@servera ~]# dnf repolist all"
history -s "dnf repolist all"
ssh student@servera "sudo dnf repolist all"

# Step 6: Disable rht-updates repository
echo "[root@servera ~]# dnf config-manager --disable rht-updates"
history -s "dnf config-manager --disable rht-updates"
ssh student@servera "sudo dnf config-manager --disable rht-updates"

# Step 7: List and install rht-system package
echo "[root@servera ~]# dnf list rht-system"
history -s "dnf list rht-system"
ssh student@servera "sudo dnf list rht-system"

echo "[root@servera ~]# dnf install rht-system"
history -s "dnf install rht-system"
ssh student@servera "sudo dnf install -y rht-system"

# Step 8: Verify rht-system package installation
echo "[root@servera ~]# dnf list rht-system"
history -s "dnf list rht-system"
ssh student@servera "sudo dnf list rht-system"

# Step 9: Enable rht-updates repository and perform software update
echo "[root@servera ~]# dnf config-manager --enable rht-updates"
history -s "dnf config-manager --enable rht-updates"
ssh student@servera "sudo dnf config-manager --enable rht-updates"

echo "[root@servera ~]# dnf update"
history -s "dnf update"
ssh student@servera "sudo dnf update -y"

# Step 10: Verify upgraded rht-system package version
echo "[root@servera ~]# dnf list rht-system"
history -s "dnf list rht-system"
ssh student@servera "sudo dnf list rht-system"

# Step 11: Exit servera
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

echo "[student@workstation ~]$ lab finish software-repo"
history -s "lab finish software-repo"
lab finish software-repo

history -w