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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start rhcsa-rh124-review1"
history -s "lab start rhcsa-rh124-review1"
lab start rhcsa-rh124-review1

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Create /home/student/grading directory
echo "[student@serverb ~]$ mkdir /home/student/grading"
history -s "mkdir /home/student/grading"
ssh student@serverb "mkdir -p /home/student/grading"

# Step 3: Create empty files grade1, grade2, grade3
echo "[student@serverb ~]$ touch /home/student/grading/grade1 /home/student/grading/grade2 /home/student/grading/grade3"
history -s "touch /home/student/grading/grade1 /home/student/grading/grade2 /home/student/grading/grade3"
ssh student@serverb "touch /home/student/grading/grade1 /home/student/grading/grade2 /home/student/grading/grade3"

# Step 4: Capture first 5 lines of /home/student/bin/manage to /home/student/grading/review.txt
echo "[student@serverb ~]$ head -n 5 /home/student/bin/manage > /home/student/grading/review.txt"
history -s "head -n 5 /home/student/bin/manage > /home/student/grading/review.txt"
ssh student@serverb "head -n 5 /home/student/bin/manage > /home/student/grading/review.txt"

# Step 5: Append last 3 lines of /home/student/bin/manage to /home/student/grading/review.txt
echo "[student@serverb ~]$ tail -n 3 /home/student/bin/manage >> /home/student/grading/review.txt"
history -s "tail -n 3 /home/student/bin/manage >> /home/student/grading/review.txt"
ssh student@serverb "tail -n 3 /home/student/bin/manage >> /home/student/grading/review.txt"

# Step 6: Copy review.txt to review-copy.txt
echo "[student@serverb ~]$ cp /home/student/grading/review.txt /home/student/grading/review-copy.txt"
history -s "cp /home/student/grading/review.txt /home/student/grading/review-copy.txt"
ssh student@serverb "cp /home/student/grading/review.txt /home/student/grading/review-copy.txt"

# Step 7: Edit review-copy.txt (Duplicate Test JJ line, remove Test HH line, add Level 1 Training line between Test BB and Test CC)
echo "[student@serverb ~]$ vim /home/student/grading/review-copy.txt"
history -s "vim /home/student/grading/review-copy.txt"

ssh student@serverb "sed -i '/Test JJ/p' /home/student/grading/review-copy.txt"
ssh student@serverb "sed -i '/Test HH/d' /home/student/grading/review-copy.txt"
ssh student@serverb "sed -i '/Test BB/a Level 1 Training' /home/student/grading/review-copy.txt"

# Step 8: Create hard link /home/student/hardcopy to /home/student/grading/grade1
echo "[student@serverb ~]$ ln /home/student/grading/grade1 /home/student/hardcopy"
history -s "ln /home/student/grading/grade1 /home/student/hardcopy"
ssh student@serverb "ln /home/student/grading/grade1 /home/student/hardcopy"

# Step 9: Create symbolic link /home/student/softcopy to /home/student/grading/grade2
echo "[student@serverb ~]$ ln -s /home/student/grading/grade2 /home/student/softcopy"
history -s "ln -s /home/student/grading/grade2 /home/student/softcopy"
ssh student@serverb "ln -s /home/student/grading/grade2 /home/student/softcopy"

# Step 10: Save long listing of /boot to /home/student/grading/longlisting.txt
echo "[student@serverb ~]$ ls -l /boot > /home/student/grading/longlisting.txt"
history -s "ls -l /boot > /home/student/grading/longlisting.txt"
ssh student@serverb "ls -l /boot > /home/student/grading/longlisting.txt"

# Step 11: Exit serverb
echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade rhcsa-rh124-review1"
history -s "lab grade rhcsa-rh124-review1"
lab grade rhcsa-rh124-review1

echo "[student@workstation ~]$ lab finish rhcsa-rh124-review1"
history -s "lab finish rhcsa-rh124-review1"
lab finish rhcsa-rh124-review1

history -w