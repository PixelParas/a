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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start users-review"
history -s "lab start users-review"
lab start users-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb and switch to root
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

echo "[student@serverb ~]$ sudo -i"
history -s "sudo -i"

# Step 2: Set default password aging policy to 30 days in /etc/login.defs
echo "[root@serverb ~]# vim /etc/login.defs"
history -s "vim /etc/login.defs"
ssh student@serverb "sudo -S sed -i 's/^PASS_MAX_DAYS.*/PASS_MAX_DAYS   30/' /etc/login.defs" <<< "student" >/dev/null 2>&1

# Step 3: Create consultants group with GID 35000
echo "[root@serverb ~]# groupadd -g 35000 consultants"
history -s "groupadd -g 35000 consultants"
ssh student@serverb "sudo -S groupadd -g 35000 consultants" <<< "student" >/dev/null 2>&1

# Step 4: Configure sudo rights for consultants group in /etc/sudoers.d/consultants
echo "[root@serverb ~]# echo \"%consultants ALL=(ALL) ALL\" > /etc/sudoers.d/consultants"
history -s "echo \"%consultants ALL=(ALL) ALL\" > /etc/sudoers.d/consultants"
ssh student@serverb "sudo -S bash -c 'echo \"%consultants ALL=(ALL) ALL\" > /etc/sudoers.d/consultants'" <<< "student" >/dev/null 2>&1

# Step 5: Create consultant users with consultants as supplementary group
echo "[root@serverb ~]# useradd -G consultants consultant1"
history -s "useradd -G consultants consultant1"
ssh student@serverb "sudo -S useradd -G consultants consultant1" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# useradd -G consultants consultant2"
history -s "useradd -G consultants consultant2"
ssh student@serverb "sudo -S useradd -G consultants consultant2" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# useradd -G consultants consultant3"
history -s "useradd -G consultants consultant3"
ssh student@serverb "sudo -S useradd -G consultants consultant3" <<< "student" >/dev/null 2>&1

# Step 6: Set passwords for consultant users to redhat
echo "[root@serverb ~]# passwd consultant1"
history -s "passwd consultant1"
ssh student@serverb "sudo -S bash -c 'echo redhat | passwd --stdin consultant1'" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# passwd consultant2"
history -s "passwd consultant2"
ssh student@serverb "sudo -S bash -c 'echo redhat | passwd --stdin consultant2'" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# passwd consultant3"
history -s "passwd consultant3"
ssh student@serverb "sudo -S bash -c 'echo redhat | passwd --stdin consultant3'" <<< "student" >/dev/null 2>&1

# Step 7: Calculate 90 days date and set account expiration for consultant users
EXP_DATE=$(ssh student@serverb "date -d '+90 days' +%F")
echo "[root@serverb ~]# date -d \"+90 days\" +%F"
history -s "date -d \"+90 days\" +%F"
echo "$EXP_DATE"

echo "[root@serverb ~]# chage -E $EXP_DATE consultant1"
history -s "chage -E $EXP_DATE consultant1"
ssh student@serverb "sudo -S chage -E $EXP_DATE consultant1" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# chage -E $EXP_DATE consultant2"
history -s "chage -E $EXP_DATE consultant2"
ssh student@serverb "sudo -S chage -E $EXP_DATE consultant2" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# chage -E $EXP_DATE consultant3"
history -s "chage -E $EXP_DATE consultant3"
ssh student@serverb "sudo -S chage -E $EXP_DATE consultant3" <<< "student" >/dev/null 2>&1

# Step 8: Set password max age to 15 days for consultant2
echo "[root@serverb ~]# chage -M 15 consultant2"
history -s "chage -M 15 consultant2"
ssh student@serverb "sudo -S chage -M 15 consultant2" <<< "student" >/dev/null 2>&1

# Step 9: Force password change on first login for consultant users
echo "[root@serverb ~]# chage -d 0 consultant1"
history -s "chage -d 0 consultant1"
ssh student@serverb "sudo -S chage -d 0 consultant1" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# chage -d 0 consultant2"
history -s "chage -d 0 consultant2"
ssh student@serverb "sudo -S chage -d 0 consultant2" <<< "student" >/dev/null 2>&1

echo "[root@serverb ~]# chage -d 0 consultant3"
history -s "chage -d 0 consultant3"
ssh student@serverb "sudo -S chage -d 0 consultant3" <<< "student" >/dev/null 2>&1

# Step 10: Exit root and logout from serverb
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

echo "[student@workstation ~]$ lab grade users-review"
history -s "lab grade users-review"
lab grade users-review

echo "[student@workstation ~]$ lab finish users-review"
history -s "lab finish users-review"
lab finish users-review

history -w