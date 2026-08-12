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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# Ensure execution starts in the home directory
cd "$HOME"

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start edit-review"
history -s "lab start edit-review"
lab start edit-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Create lab_file variable and redirect home directory listing
echo "[student@workstation ~]$ lab_file=editing_final_lab.txt"
history -s "lab_file=editing_final_lab.txt"
lab_file="editing_final_lab.txt"

echo "[student@workstation ~]$ ls -la ~ > \$lab_file"
history -s "ls -la ~ > \$lab_file"
ls -la ~ > "$lab_file"

# Step 2: Open file in vim to perform interactive visual/block edits
echo "[student@workstation ~]$ vim \$lab_file"
history -s "vim \$lab_file"

# Apply vim visual/block edit requirements programmatically:
# - Remove the first 3 lines
# - Preserve only the first 4 characters of the permissions column
# - Remove the fourth column (group)
# - Remove the time/year column (leaving only month and day)
# - Remove rows that contain "Desktop" or "Public"
python3 -c "
import sys

with open('$lab_file', 'r') as f:
    lines = f.readlines()

# Remove the first 3 lines (total count, . and ..)
lines = lines[3:]

new_lines = []
for line in lines:
    # Remove lines containing Desktop or Public
    if 'Desktop' in line or 'Public' in line:
        continue

    cols = line.split()
    # Ensure it's a standard ls -la output line
    if len(cols) >= 9:
        # cols indices: 
        # 0:perms 1:links 2:owner 3:group 4:size 5:month 6:day 7:time 8+:name
        
        # Keep only the first 4 characters of the permissions column
        perms = cols[0][:4]
        
        # Filenames might have spaces, so we join anything from index 8 onwards
        filename = ' '.join(cols[8:])
        
        # Reconstruct the line excluding group (3) and time (7)
        new_line = f'{perms} {cols[1]} {cols[2]} {cols[4]} {cols[5]} {cols[6]} {filename}\n'
        new_lines.append(new_line)
    else:
        new_lines.append(line)

with open('$lab_file', 'w') as f:
    f.writelines(new_lines)
"

# Step 3: Back up the file appending epoch timestamp in seconds
echo "[student@workstation ~]$ cp \$lab_file \${lab_file}_\$(date +%s)"
history -s "cp \$lab_file \${lab_file}_\$(date +%s)"
cp "$lab_file" "${lab_file}_$(date +%s)"

# Step 4: Append 12 dash characters line
echo "[student@workstation ~]$ echo \"------------\" >> \$lab_file"
history -s "echo \"------------\" >> \$lab_file"
echo "------------" >> "$lab_file"

# Step 5: List Documents directory, append to file and display on terminal using tee
echo "[student@workstation ~]$ ls Documents | tee -a \$lab_file"
history -s "ls Documents | tee -a \$lab_file"
ls Documents | tee -a "$lab_file"

# Step 6: Confirm bottom lines of lab_file using tail
echo "[student@workstation ~]$ tail \$lab_file"
history -s "tail \$lab_file"
tail "$lab_file"

# ============================================================
# Evaluation & Finish
# ============================================================

echo "[student@workstation ~]$ lab grade edit-review"
history -s "lab grade edit-review"
lab grade edit-review

echo "[student@workstation ~]$ lab finish edit-review"
history -s "lab finish edit-review"
lab finish edit-review

history -w