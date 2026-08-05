#!/usr/bin/env python3

import pexpect

child = pexpect.spawn("passwd", encoding="utf-8")

child.expect("Current password:")
child.sendline("student")

child.expect("New password:")
child.sendline("55TurnK3y")

child.expect("Retype new password:")
child.sendline("55TurnK3y")

child.expect(pexpect.EOF)

if child.exitstatus == 0:
    print("Password changed successfully.")
else:
    print(child.before)
