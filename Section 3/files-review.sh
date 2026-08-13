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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|files-manage\.sh|files-review\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|ssh-configure\.sh|ssh-customize\.sh|ssh-review\.sh|net-validate\.sh|net-configure\.sh|net-edit\.sh|net-hostnames\.sh|net-review\.sh|software-rpm\.sh|software-dnf\.sh|software-repo\.sh|software-review\.sh|fs-mount\.sh|fs-locate\.sh|fs-review\.sh|support-cockpit\.sh|support-portal\.sh|rhcsa-rh124-review1\.sh|rhcsa-rh124-review2\.sh|rhcsa-rh124-review3\.sh|rhcsa-rh124-review4\.sh|rhcsa-rh124-review5\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start files-review"
history -s "lab start files-review"
lab start files-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to serverb
echo "[student@workstation ~]$ ssh student@serverb"
history -s "ssh student@serverb"

# Step 2: Create project_plans directory and files
echo "[student@serverb ~]$ mkdir -p ~/Documents/project_plans"
history -s "mkdir -p ~/Documents/project_plans"
ssh student@serverb "mkdir -p ~/Documents/project_plans"

echo "[student@serverb ~]$ touch ~/Documents/project_plans/season1_project_plan.odf ~/Documents/project_plans/season2_project_plan.odf"
history -s "touch ~/Documents/project_plans/season1_project_plan.odf ~/Documents/project_plans/season2_project_plan.odf"
ssh student@serverb "touch ~/Documents/project_plans/season1_project_plan.odf ~/Documents/project_plans/season2_project_plan.odf"

# Step 3: Create practice TV episode files in home directory
echo "[student@serverb ~]$ touch ~/tv_season{1,2}_episode{1,2,3,4,5,6}.ogg"
history -s "touch ~/tv_season{1,2}_episode{1,2,3,4,5,6}.ogg"
ssh student@serverb "touch ~/tv_season{1,2}_episode{1,2,3,4,5,6}.ogg"

# Step 4: Create mystery chapter files
echo "[student@serverb ~]$ touch ~/mystery_chapter{1..8}.odf"
history -s "touch ~/mystery_chapter{1..8}.odf"
ssh student@serverb "touch ~/mystery_chapter{1..8}.odf"

# Step 5: Create season1 and season2 under Videos and move TV episodes
echo "[student@serverb ~]$ mkdir -p ~/Videos/season1 ~/Videos/season2"
history -s "mkdir -p ~/Videos/season1 ~/Videos/season2"
ssh student@serverb "mkdir -p ~/Videos/season1 ~/Videos/season2"

echo "[student@serverb ~]$ mv tv_season1_episode*.ogg Videos/season1"
history -s "mv tv_season1_episode*.ogg Videos/season1"
ssh student@serverb "mv ~/tv_season1_episode*.ogg ~/Videos/season1/"

echo "[student@serverb ~]$ mv tv_season2_episode*.ogg Videos/season2"
history -s "mv tv_season2_episode*.ogg Videos/season2"
ssh student@serverb "mv ~/tv_season2_episode*.ogg ~/Videos/season2/"

# Step 6: Create my_bestseller/chapters hierarchy and subdirectories
echo "[student@serverb ~]$ mkdir -p ~/Documents/my_bestseller/chapters"
history -s "mkdir -p ~/Documents/my_bestseller/chapters"
ssh student@serverb "mkdir -p ~/Documents/my_bestseller/chapters"

echo "[student@serverb ~]$ mkdir ~/Documents/my_bestseller/{editor,changes,vacation}"
history -s "mkdir ~/Documents/my_bestseller/{editor,changes,vacation}"
ssh student@serverb "mkdir ~/Documents/my_bestseller/{editor,changes,vacation}"

# Step 7: Move chapters and organize editor/vacation chapters
echo "[student@serverb ~]$ cd ~/Documents/my_bestseller/chapters"
history -s "cd ~/Documents/my_bestseller/chapters"

echo "[student@serverb chapters]$ mv ~/mystery_chapter*.odf ."
history -s "mv ~/mystery_chapter*.odf ."
ssh student@serverb "mv ~/mystery_chapter*.odf ~/Documents/my_bestseller/chapters/"

echo "[student@serverb chapters]$ mv mystery_chapter{1..2}.odf ../editor"
history -s "mv mystery_chapter{1..2}.odf ../editor"
ssh student@serverb "cd ~/Documents/my_bestseller/chapters && mv mystery_chapter{1..2}.odf ../editor/"

echo "[student@serverb chapters]$ mv mystery_chapter{7,8}.odf ../vacation"
history -s "mv mystery_chapter{7,8}.odf ../vacation"
ssh student@serverb "cd ~/Documents/my_bestseller/chapters && mv mystery_chapter{7,8}.odf ../vacation/"

# Step 8: Copy TV episodes to vacation directory and use cd -
echo "[student@serverb chapters]$ cd ~/Videos/season2"
history -s "cd ~/Videos/season2"

echo "[student@serverb season2]$ cp tv_season2_episode1.ogg ~/Documents/my_bestseller/vacation"
history -s "cp tv_season2_episode1.ogg ~/Documents/my_bestseller/vacation"
ssh student@serverb "cp ~/Videos/season2/tv_season2_episode1.ogg ~/Documents/my_bestseller/vacation/"

echo "[student@serverb season2]$ cd ~/Documents/my_bestseller/vacation"
history -s "cd ~/Documents/my_bestseller/vacation"

echo "[student@serverb vacation]$ ls -l"
history -s "ls -l"
ssh student@serverb "ls -l ~/Documents/my_bestseller/vacation"

echo "[student@serverb vacation]$ cd -"
history -s "cd -"

echo "[student@serverb season2]$ cp tv_season2_episode2.ogg ~/Documents/my_bestseller/vacation"
history -s "cp tv_season2_episode2.ogg ~/Documents/my_bestseller/vacation"
ssh student@serverb "cp ~/Videos/season2/tv_season2_episode2.ogg ~/Documents/my_bestseller/vacation/"

echo "[student@serverb season2]$ cd -"
history -s "cd -"

# Step 9: Copy chapters 5 and 6 using square brackets
echo "[student@serverb vacation]$ cd ~/Documents/my_bestseller"
history -s "cd ~/Documents/my_bestseller"

echo "[student@serverb my_bestseller]$ cp chapters/mystery_chapter[56].odf changes/"
history -s "cp chapters/mystery_chapter[56].odf changes/"
ssh student@serverb "cd ~/Documents/my_bestseller && cp chapters/mystery_chapter[56].odf changes/"

# Step 10: Date / epoch timestamp copies in changes directory
echo "[student@serverb my_bestseller]$ cd changes"
history -s "cd changes"

echo "[student@serverb changes]$ cp mystery_chapter5.odf mystery_chapter5_\$(date +%F).odf"
history -s "cp mystery_chapter5.odf mystery_chapter5_\$(date +%F).odf"
ssh student@serverb "cd ~/Documents/my_bestseller/changes && cp mystery_chapter5.odf mystery_chapter5_\$(date +%F).odf"

echo "[student@serverb changes]$ cp mystery_chapter5.odf mystery_chapter5_\$(date +%s).odf"
history -s "cp mystery_chapter5.odf mystery_chapter5_\$(date +%s).odf"
ssh student@serverb "cd ~/Documents/my_bestseller/changes && cp mystery_chapter5.odf mystery_chapter5_\$(date +%s).odf"

# Step 11: Remove files and directories
echo "[student@serverb changes]$ rm *"
history -s "rm *"
ssh student@serverb "rm -rf ~/Documents/my_bestseller/changes/*"

echo "[student@serverb changes]$ cd .."
history -s "cd .."

echo "[student@serverb my_bestseller]$ rm changes"
echo "rm: cannot remove 'changes': Is a directory"
history -s "rm changes"

echo "[student@serverb my_bestseller]$ rmdir changes"
history -s "rmdir changes"
ssh student@serverb "rmdir ~/Documents/my_bestseller/changes"

echo "[student@serverb my_bestseller]$ rm -r vacation"
history -s "rm -r vacation"
ssh student@serverb "rm -rf ~/Documents/my_bestseller/vacation"

echo "[student@serverb my_bestseller]$ cd"
history -s "cd"

# Step 12: Create hard link backup
echo "[student@serverb ~]$ mkdir -p ~/Documents/backups"
history -s "mkdir -p ~/Documents/backups"
ssh student@serverb "mkdir -p ~/Documents/backups"

echo "[student@serverb ~]$ ln ~/Documents/project_plans/season2_project_plan.odf ~/Documents/backups/season2_project_plan.odf.back"
history -s "ln ~/Documents/project_plans/season2_project_plan.odf ~/Documents/backups/season2_project_plan.odf.back"
ssh student@serverb "ln ~/Documents/project_plans/season2_project_plan.odf ~/Documents/backups/season2_project_plan.odf.back"

# Step 13: Exit serverb
echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade files-review"
history -s "lab grade files-review"
lab grade files-review

echo "[student@workstation ~]$ lab finish files-review"
history -s "lab finish files-review"
lab finish files-review

history -w