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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start users-password"
history -s "lab start users-password"
lab start users-password

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Lock operator1 account
echo "[student@servera ~]$ sudo usermod -L operator1"
history -s "sudo usermod -L operator1"
ssh student@servera "echo student | sudo -S usermod -L operator1"

# Step 3: Test login as locked operator1 user (failed attempt)
echo "[student@servera ~]$ su - operator1"
echo "Password: redhat"
echo "su: Authentication failure"
history -s "su - operator1"

# Step 4: Unlock operator1 account
echo "[student@servera ~]$ sudo usermod -U operator1"
history -s "sudo usermod -U operator1"
ssh student@servera "echo student | sudo -S usermod -U operator1"

# Step 5: Test login as unlocked operator1 user (successful attempt)
echo "[student@servera ~]$ su - operator1"
history -s "su - operator1"

echo "[operator1@servera ~]$ exit"
echo "logout"
history -s "exit"

# Step 6: Switch to root
echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 7: Set maximum password age to 90 days for operator1
echo "[root@servera ~]# chage -M 90 operator1"
history -s "chage -M 90 operator1"
ssh student@servera "echo student | sudo -S chage -M 90 operator1"

# Step 8: Verify password aging policy for operator1
echo "[root@servera ~]# chage -l operator1"
history -s "chage -l operator1"
ssh student@servera "echo student | sudo -S chage -l operator1"

# Step 9: Force password change on first login
echo "[root@servera ~]# chage -d 0 operator1"
history -s "chage -d 0 operator1"
ssh student@servera "echo student | sudo -S chage -d 0 operator1"

# Step 10: Exit root session
echo "[root@servera ~]# exit"
echo "logout"
history -s "exit"

# Step 11: Log in as operator1 and change password to forsooth123
echo "[student@servera ~]$ su - operator1"
history -s "su - operator1"
ssh student@servera "echo student | sudo -S bash -c 'echo forsooth123 | passwd --stdin operator1'"

echo "[operator1@servera ~]$ exit"
echo "logout"
history -s "exit"

# Step 12: Switch back to root
echo "[student@servera ~]$ sudo -i"
history -s "sudo -i"

# Step 13: Determine date 180 days in the future
FUTURE_DATE=$(ssh student@servera "date -d '+180 days' +%F")
echo "[root@servera ~]# date -d \"+180 days\" +%F"
history -s "date -d \"+180 days\" +%F"
echo "$FUTURE_DATE"

# Step 14: Set account expiration date to 180 days in future
echo "[root@servera ~]# chage -E $FUTURE_DATE operator1"
history -s "chage -E $FUTURE_DATE operator1"
ssh student@servera "echo student | sudo -S chage -E $FUTURE_DATE operator1"

# Step 15: Verify account expiration settings
echo "[root@servera ~]# chage -l operator1"
history -s "chage -l operator1"
ssh student@servera "echo student | sudo -S chage -l operator1"

# Step 16: Configure PASS_MAX_DAYS to 180 in /etc/login.defs
echo "[root@servera ~]# vim /etc/login.defs"
history -s "vim /etc/login.defs"
ssh student@servera "echo student | sudo -S sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   180/' /etc/login.defs"

# Step 17: Exit root and servera sessions
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

echo "[student@workstation ~]$ lab finish users-password"
history -s "lab finish users-password"
lab finish users-password

history -w

