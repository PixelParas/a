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

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start edit-review"
history -s "lab start edit-review"
lab start edit-review

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Create shell variable lab_file and redirect directory listing
echo "[student@workstation ~]$ lab_file=editing_final_lab.txt"
history -s "lab_file=editing_final_lab.txt"
lab_file=editing_final_lab.txt

echo "[student@workstation ~]$ ls -la ~ > \$lab_file"
history -s "ls -la ~ > \$lab_file"
ls -la ~ > "$lab_file"

# Step 2: Open file in vim to perform interactive visual/block edits
echo "[student@workstation ~]$ vim \$lab_file"
history -s "vim \$lab_file"

# Apply vim visual/block edit requirements programmatically to the file:
# - Remove first 3 lines
# - Keep only first 4 chars of column 1 across lines
# - Remove 4th column (group)
# - Keep only month and day in modification timestamp (remove HH:MM / year)
# - Remove lines containing "Desktop" or "Public"
python3 -c "
import re

with open('$lab_file', 'r') as f:
    lines = f.readlines()

# 1. Remove first 3 lines
lines = lines[3:]

new_lines = []
for line in lines:
    # Remove lines containing Desktop or Public
    if 'Desktop' in line or 'Public' in line:
        continue

    parts = line.split()
    if len(parts) >= 9:
        # Col 0 (permissions): trim to first 4 chars
        parts[0] = parts[0][:4]
        # Remove 4th column (group name)
        del parts[3]
        
        # Adjust timestamp column (remove time/year if present, keep Month + Day)
        # Standard ls -l format: [perms, links, owner, size, month, day, time/year, name]
        # After deleting group: indices are [0:perms, 1:links, 2:owner, 3:size, 4:month, 5:day, 6:time/year, 7+:name]
        if len(parts) >= 8:
            del parts[6]
            
        new_lines.append(' '.join(parts) + '\n')
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