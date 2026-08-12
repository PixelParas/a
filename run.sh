#!/usr/bin/env bash
set -euo pipefail

# Order of scripts to execute based on section progression
SCRIPTS=(
    "Section 2/cli-desktop.sh"
    "Section 2/cli-review.sh"
    "Section 3/files-manage.sh"
    "Section 3/files-make.sh"
    "Section 3/files-review.sh"
    "Section 4/help-manual.sh"
    "Section 4/help-review.sh"
    "Section 5/edit-editfile.sh"
    "Section 5/edit-bashconfig.sh"
    "Section 5/edit-review.sh"
    "Section 6/users-superuser.sh"
    "Section 6/users-user.sh"
    "Section 6/users-group.sh"
    "Section 6/users-password.sh"
    "Section 6/users-review.sh"
    "Section 7/perms-cli.sh"
    "Section 7/perms-default.sh"
    "Section 7/perms-review.sh"
    # Section 8 (from tree structure)
    "Section 8/processes-control.sh"
    "Section 8/processes-kill.sh"
    "Section 8/processes-monitor.sh"
    "Section 8/processes-review.sh"
)

echo "Starting execution sequence..."

for script in "${SCRIPTS[@]}"; do
    if [[ -f "$script" ]]; then
        echo "=========================================="
        echo " Executing: $script"
        echo "=========================================="
        "./$script"
    else
        echo "[WARNING] Script not found: $script. Skipping..."
    fi
done

echo "=========================================="
echo "All scripts executed successfully."