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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|cli-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start cli-review"
history -s "lab start cli-review"
lab start cli-review

# ============================================================
# Instructions Execution
# ============================================================

# Step 1: Display current time and date
echo "[student@workstation ~]$ date"
history -s "date"
date

# Step 2: Display time in 24-hour clock time (%R)
echo "[student@workstation ~]$ date +%R"
history -s "date +%R"
date +%R

# Step 3: Identify file type of /home/student/zcat
echo "[student@workstation ~]$ file /home/student/zcat"
history -s "file /home/student/zcat"
file /home/student/zcat

# Step 4: Display size of zcat file using wc
echo "[student@workstation ~]$ wc /home/student/zcat"
history -s "wc /home/student/zcat"
wc /home/student/zcat

# Step 5: Display first 10 lines of zcat
echo "[student@workstation ~]$ head /home/student/zcat"
history -s "head /home/student/zcat"
head /home/student/zcat

# Step 6: Display last 10 lines of zcat
echo "[student@workstation ~]$ tail /home/student/zcat"
history -s "tail /home/student/zcat"
tail /home/student/zcat

# Step 7: Repeat previous command with history shortcut
echo "[student@workstation ~]$ !!"
echo "tail /home/student/zcat"
history -s "!!"
tail /home/student/zcat

# Step 8: Display last 20 lines using tail -n 20
echo "[student@workstation ~]$ tail -n 20 /home/student/zcat"
history -s "tail -n 20 /home/student/zcat"
tail -n 20 /home/student/zcat

# Step 9: Re-run date +%R command using history shortcut
echo "[student@workstation ~]$ !date"
echo "date +%R"
history -s "!date"
date +%R

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade cli-review"
history -s "lab grade cli-review"
lab grade cli-review

echo "[student@workstation ~]$ lab finish cli-review"
history -s "lab finish cli-review"
lab finish cli-review

history -w