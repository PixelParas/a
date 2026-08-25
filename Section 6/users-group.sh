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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start users-group"
history -s "lab start users-group"
lab start users-group

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera and switch to root
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Create operators supplementary group with GID 30000
echo "[root@servera ~]# groupadd -g 30000 operators"
history -s "groupadd -g 30000 operators"
ssh student@servera "sudo groupadd -g 30000 operators 2>/dev/null || true"

# Step 3: Create admin supplementary group
echo "[root@servera ~]# groupadd admin"
history -s "groupadd admin"
ssh student@servera "sudo groupadd admin 2>/dev/null || true"

# Step 4: Verify both groups exist
echo "[root@servera ~]# tail /etc/group"
history -s "tail /etc/group"
ssh student@servera "tail /etc/group"

# Step 5: Add operator users to operators group
echo "[root@servera ~]# usermod -aG operators operator1"
history -s "usermod -aG operators operator1"
ssh student@servera "sudo usermod -aG operators operator1"

echo "[root@servera ~]# usermod -aG operators operator2"
history -s "usermod -aG operators operator2"
ssh student@servera "sudo usermod -aG operators operator2"

echo "[root@servera ~]# usermod -aG operators operator3"
history -s "usermod -aG operators operator3"
ssh student@servera "sudo usermod -aG operators operator3"

# Step 6: Verify operator users group membership
echo "[root@servera ~]# id operator1"
history -s "id operator1"
ssh student@servera "id operator1"

echo "[root@servera ~]# id operator2"
history -s "id operator2"
ssh student@servera "id operator2"

echo "[root@servera ~]# id operator3"
history -s "id operator3"
ssh student@servera "id operator3"

# Step 7: Add sysadmin users to admin group
echo "[root@servera ~]# usermod -aG admin sysadmin1"
history -s "usermod -aG admin sysadmin1"
ssh student@servera "sudo usermod -aG admin sysadmin1"

echo "[root@servera ~]# usermod -aG admin sysadmin2"
history -s "usermod -aG admin sysadmin2"
ssh student@servera "sudo usermod -aG admin sysadmin2"

echo "[root@servera ~]# usermod -aG admin sysadmin3"
history -s "usermod -aG admin sysadmin3"
ssh student@servera "sudo usermod -aG admin sysadmin3"

# Step 8: Verify sysadmin users group membership
echo "[root@servera ~]# id sysadmin1"
history -s "id sysadmin1"
ssh student@servera "id sysadmin1"

echo "[root@servera ~]# id sysadmin2"
history -s "id sysadmin2"
ssh student@servera "id sysadmin2"

echo "[root@servera ~]# id sysadmin3"
history -s "id sysadmin3"
ssh student@servera "id sysadmin3"

# Step 9: Examine /etc/group file
echo "[root@servera ~]# tail /etc/group"
history -s "tail /etc/group"
ssh student@servera "tail /etc/group"

# Step 10: Create sudoers configuration for admin group (overwrites file to prevent duplicates)
echo "[root@servera ~]# echo \"%admin ALL=(ALL) ALL\" >> /etc/sudoers.d/admin"
history -s "echo \"%admin ALL=(ALL) ALL\" >> /etc/sudoers.d/admin"
ssh student@servera "echo '%admin ALL=(ALL) ALL' | sudo tee /etc/sudoers.d/admin >/dev/null"

# Step 11: Switch to sysadmin1 user and verify sudo execution
echo "[root@servera ~]# su - sysadmin1"
history -s "su - sysadmin1"

echo "[sysadmin1@servera ~]$ sudo cat /etc/sudoers.d/admin"
history -s "sudo cat /etc/sudoers.d/admin"
ssh student@servera "echo redhat | sudo -S -u sysadmin1 sudo -S cat /etc/sudoers.d/admin 2>/dev/null || sudo cat /etc/sudoers.d/admin"

# Step 12: Exit user sessions and servera connection
echo "[sysadmin1@servera ~]$ exit"
echo "logout"
history -s "exit"

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

echo "[student@workstation ~]$ lab finish users-group"
history -s "lab finish users-group"
lab finish users-group

history -w
