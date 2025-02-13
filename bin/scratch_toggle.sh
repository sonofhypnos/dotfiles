#!/usr/bin/env python3

import sys
import subprocess


def toggle_scratchpad(app_class, app_instance, command):
    """Toggle an application in the scratchpad or launch it if not found."""
    # tree = get_i3_tree()
    # window_id = find_window(tree, app_class, app_instance)

    # if window_id:
    #     subprocess.run(["i3-msg", f"[id={window_id}] scratchpad show"])
    # else:

    result = subprocess.run(
        ["i3-msg", f'[class="{app_class}" instance="{app_instance}"] scratchpad show']
    )
    if 0 != result.returncode:
        subprocess.run(["i3-msg", f"exec {command}"])


if __name__ == "__main__":
    if len(sys.argv) < 3:
        print("Usage: scratch_toggle.py <class> <command> [instance]")
        sys.exit(1)

    app_class = sys.argv[1]
    command = sys.argv[2]
    print(command)
    app_instance = sys.argv[3] if len(sys.argv) > 3 else None

    toggle_scratchpad(app_class, app_instance, command)
