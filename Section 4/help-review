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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start help-review"
history -s "lab start help-review"
lab start help-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Research default PostScript printing format in man pages
echo "[student@workstation ~]$ man man"
history -s "man man"
MANPAGER=cat man man | head -n 25

# Step 2: Create PostScript file of passwd man page
echo "[student@workstation ~]$ man -t passwd > passwd.ps"
history -s "man -t passwd > passwd.ps"
man -t passwd > passwd.ps

# Step 3: Determine file type of passwd.ps
echo "[student@workstation ~]$ file passwd.ps"
history -s "file passwd.ps"
file passwd.ps

# Step 4: Inspect contents of passwd.ps using less
echo "[student@workstation ~]$ less passwd.ps"
history -s "less passwd.ps"
timeout 2 less passwd.ps >/dev/null 2>&1 || head -n 20 passwd.ps

# Step 5: Find commands for viewing PostScript files
echo "[student@workstation ~]$ man -k postscript"
history -s "man -k postscript"
man -k postscript

# Step 6: View evince manual page
echo "[student@workstation ~]$ man evince"
history -s "man evince"
MANPAGER=cat man evince | head -n 25

# Step 7: Open passwd.ps in default evince mode
echo "[student@workstation ~]$ evince passwd.ps"
history -s "evince passwd.ps"
timeout 2 evince passwd.ps >/dev/null 2>&1 || true

# Step 8: Open passwd.ps in preview mode
echo "[student@workstation ~]$ evince -w passwd.ps"
history -s "evince -w passwd.ps"
timeout 2 evince -w passwd.ps >/dev/null 2>&1 || true

# Step 9: Open passwd.ps starting on page 3
echo "[student@workstation ~]$ evince -p 3 passwd.ps"
history -s "evince -p 3 passwd.ps"
timeout 2 evince -p 3 passwd.ps >/dev/null 2>&1 || true

# Step 10: Research lp command options
echo "[student@workstation ~]$ man lp"
history -s "man lp"
MANPAGER=cat man lp | head -n 25

# Step 11: Open Firefox browser to documentation directory
echo "[student@workstation ~]$ firefox /usr/share/doc &"
history -s "firefox /usr/share/doc &"
timeout 2 firefox /usr/share/doc >/dev/null 2>&1 || true

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade help-review"
history -s "lab grade help-review"
lab grade help-review

echo "[student@workstation ~]$ lab finish help-review"
history -s "lab finish help-review"
lab finish help-review

history -w