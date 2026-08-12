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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start perms-review"
history -s "lab start perms-review"
lab start perms-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Create /home/techdocs directory
echo "[root@serverb ~]# mkdir /home/techdocs"
history -s "mkdir /home/techdocs"
ssh student@serverb "sudo mkdir -p /home/techdocs"

# Step 3: Change group ownership of /home/techdocs to techdocs
echo "[root@serverb ~]# chown :techdocs /home/techdocs"
history -s "chown :techdocs /home/techdocs"
ssh student@serverb "sudo chown :techdocs /home/techdocs"

# Step 4: Verify initial directory permissions
echo "[root@serverb ~]# ls -ld /home/techdocs"
history -s "ls -ld /home/techdocs"
ssh student@serverb "ls -ld /home/techdocs"

# Step 5: Set permissions to 2770 (setgid, rwx for owner/group, no access for others)
echo "[root@serverb ~]# chmod 2770 /home/techdocs"
history -s "chmod 2770 /home/techdocs"
ssh student@serverb "sudo chmod 2770 /home/techdocs"

# Step 6: Verify updated directory permissions
echo "[root@serverb ~]# ls -ld /home/techdocs"
history -s "ls -ld /home/techdocs"
ssh student@serverb "ls -ld /home/techdocs"

# Step 7: Verify tech1 (member of techdocs) can create files in /home/techdocs
echo "[root@serverb ~]# su - tech1"
history -s "su - tech1"

echo "[tech1@serverb ~]$ touch /home/techdocs/tech1.txt"
history -s "touch /home/techdocs/tech1.txt"
ssh student@serverb "sudo -u tech1 touch /home/techdocs/tech1.txt"

echo "[tech1@serverb ~]$ exit"
echo "logout"
history -s "exit"

# Step 8: Update UMASK to 077 in /etc/login.defs for login shells
echo "[root@serverb ~]# vim /etc/login.defs"
history -s "vim /etc/login.defs"
ssh student@serverb "sudo sed -i 's/^UMASK.*/UMASK           077/' /etc/login.defs"

# Step 9: Exit root shell and log out from serverb
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

echo "[student@workstation ~]$ lab grade perms-review"
history -s "lab grade perms-review"
lab grade perms-review

echo "[student@workstation ~]$ lab finish perms-review"
history -s "lab finish perms-review"
lab finish perms-review

history -w