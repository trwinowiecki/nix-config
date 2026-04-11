#!/usr/bin/env python3
"""
Focus Time Daemon
Runs in the background to track focus sessions and provide notifications.
"""

import json
import os
import time
from pathlib import Path

STATE_FILE = "/tmp/focus_state.json"

def load_state():
    try:
        with open(STATE_FILE, 'r') as f:
            return json.load(f)
    except:
        return {"running": False, "remaining": 0, "is_break": False}

def save_state(state):
    with open(STATE_FILE, 'w') as f:
        json.dump(state, f)

def notify(title, message):
    os.system(f'notify-send "{title}" "{message}"')

def main():
    print("Focus daemon started")
    save_state({"running": False, "remaining": 0, "is_break": False})

    while True:
        time.sleep(1)
        state = load_state()

        if state.get("running") and state.get("remaining", 0) > 0:
            state["remaining"] -= 1
            save_state(state)

            if state["remaining"] == 0:
                state["running"] = False
                save_state(state)
                if state.get("is_break"):
                    notify("Focus Timer", "Break time is over! Time to focus.")
                else:
                    notify("Focus Timer", "Focus session complete! Take a break.")

if __name__ == "__main__":
    main()
