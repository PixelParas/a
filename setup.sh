#!/usr/bin/env bash
set -euo pipefail

echo "Making all .sh files in Section directories executable..."

# Find all .sh files under Section directories and apply execute permissions
find . -type f -path "./Section*/*.sh" -exec chmod +x {} +

# Ensure setup.sh and run.sh (if present) are also executable
chmod +x "$0"
if [[ -f "run.sh" ]]; then
    chmod +x run.sh
fi

echo "Setup complete. All scripts are now executable."