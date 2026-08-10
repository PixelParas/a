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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|help-manual\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start help-manual"
history -s "lab start help-manual"
lab start help-manual

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: View gedit man page
echo "[student@workstation ~]$ man gedit"
history -s "man gedit"
MANPAGER=cat man gedit | head -n 25

# Step 2: Open manual file with gedit at the end of the line
echo "[student@workstation ~]$ gedit + manual"
history -s "gedit + manual"
timeout 2 gedit + manual >/dev/null 2>&1 || true

# Step 3: View su(1) man page
echo "[student@workstation ~]$ man 1 su"
history -s "man 1 su"
MANPAGER=cat man 1 su | head -n 25

# Step 4: View man(1) man page
echo "[student@workstation ~]$ man man"
history -s "man man"
MANPAGER=cat man man | head -n 25

# Step 5: Display one-line description of the w command
echo "[student@workstation ~]$ man -f w"
history -s "man -f w"
man -f w

# Step 6: List man page for ZIP archive information
echo "[student@workstation ~]$ man -k zip"
history -s "man -k zip"
man -k zip

# Step 7: List man page for kernel boot parameters
echo "[student@workstation ~]$ man -k boot"
history -s "man -k boot"
man -k boot

# Step 8: Find command to tune ext4 file-system parameters
echo "[student@workstation ~]$ man -k ext4"
history -s "man -k ext4"
man -k ext4

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish help-manual"
history -s "lab finish help-manual"
lab finish help-manual

history -w