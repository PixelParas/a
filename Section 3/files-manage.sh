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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|files-manage\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|rhcsa-rh124-review3\.sh|rhcsa-rh124-review4\.sh|rhcsa-rh124-review5\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start files-manage"
history -s "lab start files-manage"
lab start files-manage

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Create Music, Pictures, and Videos subdirectories
echo "[student@servera ~]$ mkdir Music Pictures Videos"
history -s "mkdir Music Pictures Videos"
ssh student@servera "mkdir -p Music Pictures Videos"

# Step 3: Create practice files using touch
echo "[student@servera ~]$ touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3"
history -s "touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3"
ssh student@servera "touch song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3"

echo "[student@servera ~]$ touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg"
history -s "touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg"
ssh student@servera "touch snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg"

echo "[student@servera ~]$ touch film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi"
history -s "touch film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi"
ssh student@servera "touch film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi"

echo "[student@servera ~]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l"

# Step 4: Move media files to their respective subdirectories
echo "[student@servera ~]$ mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3 Music"
history -s "mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3 Music"
ssh student@servera "mv song1.mp3 song2.mp3 song3.mp3 song4.mp3 song5.mp3 song6.mp3 Music"

echo "[student@servera ~]$ mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg Pictures"
history -s "mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg Pictures"
ssh student@servera "mv snap1.jpg snap2.jpg snap3.jpg snap4.jpg snap5.jpg snap6.jpg Pictures"

echo "[student@servera ~]$ mv film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi Videos"
history -s "mv film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi Videos"
ssh student@servera "mv film1.avi film2.avi film3.avi film4.avi film5.avi film6.avi Videos"

echo "[student@servera ~]$ ls -l Music Pictures Videos"
history -s "ls -l Music Pictures Videos"
ssh student@servera "ls -l Music Pictures Videos"

# Step 5: Create friends, family, and work subdirectories
echo "[student@servera ~]$ mkdir friends family work"
history -s "mkdir friends family work"
ssh student@servera "mkdir -p friends family work"

echo "[student@servera ~]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l"

# Step 6: Copy files 1 and 2 to friends directory
echo "[student@servera ~]$ cd friends"
history -s "cd friends"

echo "[student@servera friends]$ cp ~/Music/song1.mp3 ~/Music/song2.mp3 ~/Pictures/snap1.jpg ~/Pictures/snap2.jpg ~/Videos/film1.avi ~/Videos/film2.avi ."
history -s "cp ~/Music/song1.mp3 ~/Music/song2.mp3 ~/Pictures/snap1.jpg ~/Pictures/snap2.jpg ~/Videos/film1.avi ~/Videos/film2.avi ."
ssh student@servera "cp ~/Music/song1.mp3 ~/Music/song2.mp3 ~/Pictures/snap1.jpg ~/Pictures/snap2.jpg ~/Videos/film1.avi ~/Videos/film2.avi ~/friends/"

echo "[student@servera friends]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l ~/friends"

# Step 7: Copy files 3 and 4 to family directory
echo "[student@servera friends]$ cd ../family"
history -s "cd ../family"

echo "[student@servera family]$ cp ~/Music/song3.mp3 ~/Music/song4.mp3 ~/Pictures/snap3.jpg ~/Pictures/snap4.jpg ~/Videos/film3.avi ~/Videos/film4.avi ."
history -s "cp ~/Music/song3.mp3 ~/Music/song4.mp3 ~/Pictures/snap3.jpg ~/Pictures/snap4.jpg ~/Videos/film3.avi ~/Videos/film4.avi ."
ssh student@servera "cp ~/Music/song3.mp3 ~/Music/song4.mp3 ~/Pictures/snap3.jpg ~/Pictures/snap4.jpg ~/Videos/film3.avi ~/Videos/film4.avi ~/family/"

echo "[student@servera family]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l ~/family"

# Step 8: Copy family and friends directories into work directory
echo "[student@servera family]$ cd ../work"
history -s "cd ../work"

echo "[student@servera work]$ cp -r ~/family ~/friends ."
history -s "cp -r ~/family ~/friends ."
ssh student@servera "cp -r ~/family ~/friends ~/work/"

echo "[student@servera work]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l ~/work"

# Step 9: Clean up created directories
echo "[student@servera work]$ cd .."
history -s "cd .."

echo "[student@servera ~]$ rm -r family friends work"
history -s "rm -r family friends work"
ssh student@servera "rm -rf ~/family ~/friends ~/work"

echo "[student@servera ~]$ ls -l"
history -s "ls -l"
ssh student@servera "ls -l"

# Step 10: Exit servera
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish files-manage"
history -s "lab finish files-manage"
lab finish files-manage

history -w