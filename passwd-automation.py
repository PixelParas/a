#!/usr/bin/env python3

import time
from pynput.keyboard import Controller, Key

keyboard = Controller()


def type_text(text):
    keyboard.type(text)
    keyboard.press(Key.enter)
    keyboard.release(Key.enter)


# Give the terminal/passwd prompt time to appear
time.sleep(2)

# Current password
type_text("student")

time.sleep(1)

# New password
type_text("55TurnK3y")

time.sleep(1)

# Retype new password
type_text("55TurnK3y")
