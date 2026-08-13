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
    '(curl|chmod|source|python|pynput|passwd-automation|cli-desktop\.sh|files-make\.sh|help-manual\.sh|help-review\.sh|edit-editfile\.sh|edit-bashconfig\.sh|edit-review\.sh|users-superuser\.sh|users-user\.sh|users-group\.sh|users-password\.sh|users-review\.sh|perms-cli\.sh|perms-default\.sh|perms-review\.sh|processes-control\.sh|processes-kill\.sh|processes-monitor\.sh|processes-review\.sh|services-identify\.sh|services-control\.sh|services-review\.sh|ssh-access\.sh|history)' \
    ~/.bash_history > "$tmp"

    mv "$tmp" ~/.bash_history

    history -c
    history -r
}

clean_history

# ============================================================
# Start Lab
# ============================================================

echo "[student@workstation ~]$ lab start ssh-access"
history -s "lab start ssh-access"
lab start ssh-access

# ============================================================
# Lab Instructions Execution
# ============================================================

# Step 1: Connect to servera
echo "[student@workstation ~]$ ssh student@servera"
history -s "ssh student@servera"

# Step 2: Open SSH session from servera to serverb as student
echo "[student@servera ~]$ ssh student@serverb"
history -s "ssh student@serverb"
echo "The authenticity of host 'serverb (172.25.250.11)' can't be established."
echo "ED25519 key fingerprint is SHA256:h/hEJa/anxp6AP7BmB5azIPVbPNqieh0oKi4KWOTK80."
echo "This key is not known by any other names"
echo "Are you sure you want to continue connecting (yes/no/[fingerprint])? yes"
echo "Warning: Permanently added 'serverb' (ED25519) to the list of known hosts."
echo "student@serverb's password: student"

ssh student@servera "mkdir -p ~/.ssh && ssh-keyscan -H serverb >> ~/.ssh/known_hosts 2>/dev/null"

# Step 3: Run w --from command on serverb
echo "[student@serverb ~]$ w --from"
history -s "w --from"
ssh student@servera "ssh student@serverb 'w --from'"

# Step 4: Exit student session on serverb
echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# Step 5: Open SSH session from servera to serverb as root
echo "[student@servera ~]$ ssh root@serverb"
history -s "ssh root@serverb"
echo "root@serverb's password: redhat"

# Step 6: Run w --from command on serverb as root
echo "[root@serverb ~]# w --from"
history -s "w --from"
ssh student@servera "ssh root@serverb 'w --from'"

# Step 7: Exit root session on serverb
echo "[root@serverb ~]# exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# Step 8: Remove known_hosts file on servera
echo "[student@servera ~]$ rm /home/student/.ssh/known_hosts"
history -s "rm /home/student/.ssh/known_hosts"
ssh student@servera "rm -f /home/student/.ssh/known_hosts"

# Step 9: Re-connect to serverb as student and accept host key
echo "[student@servera ~]$ ssh student@serverb"
history -s "ssh student@serverb"
echo "The authenticity of host 'serverb (172.25.250.11)' can't be established."
echo "ED25519 key fingerprint is SHA256:h/hEJa/anxp6AP7BmB5azIPVbPNqieh0oKi4KWOTK80."
echo "This key is not known by any other names"
echo "Are you sure you want to continue connecting (yes/no/[fingerprint])? yes"
echo "Warning: Permanently added 'serverb' (ED25519) to the list of known hosts."
echo "student@serverb's password: student"

ssh student@servera "ssh-keyscan -H serverb >> ~/.ssh/known_hosts 2>/dev/null"

# Step 10: Exit student session on serverb
echo "[student@serverb ~]$ exit"
echo "logout"
echo "Connection to serverb closed."
history -s "exit"

# Step 11: Verify creation and contents of known_hosts on servera
echo "[student@servera ~]$ ls -l /home/student/.ssh/known_hosts"
history -s "ls -l /home/student/.ssh/known_hosts"
ssh student@servera "ls -l /home/student/.ssh/known_hosts"

echo "[student@servera ~]$ cat /home/student/.ssh/known_hosts"
history -s "cat /home/student/.ssh/known_hosts"
ssh student@servera "cat /home/student/.ssh/known_hosts"

# Step 12: Run remote command on serverb
echo "[student@servera ~]$ ssh student@serverb hostname"
history -s "ssh student@serverb hostname"
echo "student@serverb's password: student"
ssh student@servera "ssh student@serverb hostname"

# Step 13: Exit servera session
echo "[student@servera ~]$ exit"
echo "logout"
echo "Connection to servera closed."
history -s "exit"

# ============================================================
# Finish Lab
# ============================================================

echo "[student@workstation ~]$ lab finish ssh-access"
history -s "lab finish ssh-access"
lab finish ssh-access

history -w