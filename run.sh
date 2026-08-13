#!/bin/bash

# ==============================================================================
# RHCSA RH124 Lab Execution Script
# Runs all lab solution scripts in chronological sequence per curriculum order.
# ==============================================================================

# Section 2: Accessing the Command Line
echo "[+] Running Section 2..."
source "Section 2/cli-desktop.sh"
source "Section 2/cli-review.sh"

# Section 3: Managing Files From the Command Line
echo "[+] Running Section 3..."
source "Section 3/files-manage.sh"
source "Section 3/files-make.sh"
source "Section 3/files-review.sh"

# Section 4: Getting Help in Red Hat Enterprise Linux
echo "[+] Running Section 4..."
source "Section 4/help-manual.sh"
source "Section 4/help-review.sh"

# Section 5: Creating, Viewing, and Editing Text Files
echo "[+] Running Section 5..."
source "Section 5/edit-editfile.sh"
source "Section 5/edit-bashconfig.sh"
source "Section 5/edit-review.sh"

# Section 6: Managing Local Users and Groups
echo "[+] Running Section 6..."
source "Section 6/users-superuser.sh"
source "Section 6/users-user.sh"
source "Section 6/users-group.sh"
source "Section 6/users-password.sh"
source "Section 6/users-review.sh"

# Section 7: Controlling Access to Files
echo "[+] Running Section 7..."
source "Section 7/perms-cli.sh"
source "Section 7/perms-default.sh"
source "Section 7/perms-review.sh"

# Section 8: Monitoring and Managing Linux Processes
echo "[+] Running Section 8..."
source "Section 8/processes-control.sh"
source "Section 8/processes-kill.sh"
source "Section 8/processes-monitor.sh"
source "Section 8/processes-review.sh"

# Section 9: Controlling Services and Daemons
echo "[+] Running Section 9..."
source "Section 9/services-identify.sh"
source "Section 9/services-control.sh"
source "Section 9/services-review.sh"

# Section 10: Configuring and Securing SSH
echo "[+] Running Section 10..."
source "Section 10/ssh-access.sh"
source "Section 10/ssh-configure.sh"
source "Section 10/ssh-customize.sh"
source "Section 10/ssh-review.sh"

# Section 11: Managing Networking
echo "[+] Running Section 11..."
source "Section 11/net-validate.sh"
source "Section 11/net-configure.sh"
source "Section 11/net-edit.sh"
source "Section 11/net-hostnames.sh"
source "Section 11/net-review.sh"

# Section 12: Installing and Updating Software Packages
echo "[+] Running Section 12..."
source "Section 12/software-rpm.sh"
source "Section 12/software-dnf.sh"
source "Section 12/software-repo.sh"
source "Section 12/software-review.sh"

# Section 13: Accessing Linux File Systems
echo "[+] Running Section 13..."
source "Section 13/fs-mount.sh"
source "Section 13/fs-locate.sh"
source "Section 13/fs-review.sh"

# Section 14: Analyzing Servers and Getting Support
echo "[+] Running Section 14..."
source "Section 14/support-cockpit.sh"
source "Section 14/support-portal.sh"

# Section 15: Comprehensive Review
echo "[+] Running Section 15..."
source "Section 15/rhcsa-rh124-review1.sh"
source "Section 15/rhcsa-rh124-review2.sh"
source "Section 15/rhcsa-rh124-review3.sh"
source "Section 15/rhcsa-rh124-review4.sh"
source "Section 15/rhcsa-rh124-review5.sh"
