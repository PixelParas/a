import sys
import pexpect

child = pexpect.spawn("passwd", encoding="utf-8")
child.logfile = sys.stdout

child.expect_exact("Current password:")
child.sendline("student")

child.expect_exact("New password:")
child.sendline("55TurnK3y")

child.expect_exact("Retype new password:")
child.sendline("55TurnK3y")

child.expect(pexpect.EOF)

print("exitstatus =", child.exitstatus)
print("before =", repr(child.before))
