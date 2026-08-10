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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start edit-bashconfig"
history -s "lab start edit-bashconfig"
lab start edit-bashconfig

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Open ~/.bashrc in vim to edit
echo "[student@servera ~]$ vim ~/.bashrc"
history -s "vim ~/.bashrc"
ssh student@servera "echo \"export PS1='[\u@\h \t \w]\$ '\" >> ~/.bashrc"

# Step 3: Exit servera to apply changes on next login
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# Step 4: Re-connect to servera to load updated PS1 prompt
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 5: Assign value to the file variable
echo "[student@servera 14:47:05 ~]$ file=tmp.zdkei083"
history -s "file=tmp.zdkei083"
ssh student@servera "file=tmp.zdkei083"

# Step 6: Echo the file variable value
echo "[student@servera 14:48:35 ~]$ echo \$file"
history -s "echo \$file"
ssh student@servera "file=tmp.zdkei083; echo \$file"

# Step 7: List the file using the variable
echo "[student@servera 14:59:07 ~]$ ls -l \$file"
history -s "ls -l \$file"
ssh student@servera "file=tmp.zdkei083; ls -l \$file"

# Step 8: Delete the file using the variable
echo "[student@servera 14:59:10 ~]$ rm \$file"
history -s "rm \$file"
ssh student@servera "file=tmp.zdkei083; rm \$file"

# Step 9: Verify the file deletion
echo "[student@servera 14:59:15 ~]$ ls -l \$file"
history -s "ls -l \$file"
ssh student@servera "file=tmp.zdkei083; ls -l \$file"

# Step 10: Export EDITOR environment variable
echo "[student@servera 14:46:40 ~]$ export EDITOR=vim"
history -s "export EDITOR=vim"
ssh student@servera "export EDITOR=vim"

# Step 11: Verify EDITOR environment variable
echo "[student@servera 14:46:55 ~]$ echo \$EDITOR"
history -s "echo \$EDITOR"
ssh student@servera "export EDITOR=vim; echo \$EDITOR"

# Step 12: Exit servera session and return to workstation
echo "[student@servera 14:47:11 ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish edit-bashconfig"
history -s "lab finish edit-bashconfig"
lab finish edit-bashconfig

history -w