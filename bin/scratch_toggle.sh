#!/usr/bin/env python3

import sys
import subprocess
import json

def get_i3_tree():
    """Get the i3 window tree as a dictionary."""
    result = subprocess.run(["i3-msg", "-t", "get_tree"], capture_output=True, text=True)
    return json.loads(result.stdout) if result.returncode == 0 else {}

def find_window(tree, app_class, app_instance=None):
    """Recursively search for a window by class and optionally instance."""
    if "nodes" in tree:
        for node in tree["nodes"]:
            found = find_window(node, app_class, app_instance)
            if found:
                return found
    if "floating_nodes" in tree:
        for node in tree["floating_nodes"]:
            found = find_window(node, app_class, app_instance)
            if found:
                return found
    if tree.get("window_properties"):
        properties = tree["window_properties"]
        if properties.get("class") == app_class and (app_instance is None or properties.get("instance") == app_instance):
            return tree["id"]
    return None

def toggle_scratchpad(app_class, app_instance, command):
    """Toggle an application in the scratchpad or launch it if not found."""
    tree = get_i3_tree()
    window_id = find_window(tree, app_class, app_instance)

    if window_id:
        subprocess.run(["i3-msg", f"[id={window_id}] scratchpad show"])
    else:
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
