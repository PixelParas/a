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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start files-make"
history -s "lab start files-make"
lab start files-make

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Check target file details
echo "[student@servera ~]$ ls -li files/target.file"
history -s "ls -li files/target.file"
ssh student@servera "ls -li files/target.file"

# Step 3: Create hard link
echo "[student@servera ~]$ ln files/target.file links/file.hardlink"
history -s "ln files/target.file links/file.hardlink"
ssh student@servera "ln files/target.file links/file.hardlink"

# Step 4: Verify inode and link count for hard link
echo "[student@servera ~]$ ls -li files/target.file links/file.hardlink"
history -s "ls -li files/target.file links/file.hardlink"
ssh student@servera "ls -li files/target.file links/file.hardlink"

# Step 5: Create symbolic link
echo "[student@servera ~]$ ln -s /tmp /home/student/tempdir"
history -s "ln -s /tmp /home/student/tempdir"
ssh student@servera "ln -s /tmp /home/student/tempdir"

# Step 6: Verify symbolic link
echo "[student@servera ~]$ ls -li /home/student/tempdir"
history -s "ls -li /home/student/tempdir"
ssh student@servera "ls -li /home/student/tempdir"

# Step 7: Return to workstation system
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish files-make"
history -s "lab finish files-make"
lab finish files-make

history -w