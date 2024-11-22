#!/usr/bin/env python3

import subprocess
import os
from pathlib import Path
import sys
import questionary

SUPPORTED_EXTENSIONS = {".sh", ".py"}
BASE_DIR = "scripts"

def discover_subdirectories(base_dir):
    """Discover all subdirectories in the given directory."""
    base_path = Path(base_dir)
    if not base_path.exists():
        print(f"Error: Directory '{base_dir}' does not exist.")
        sys.exit(1)

    subdirs = [d for d in base_path.iterdir() if d.is_dir()]
    return subdirs

def discover_scripts_in_subdirectory(subdir):
    """Find all scripts in the specified subdirectory."""
    scripts = [f for f in subdir.iterdir() if f.is_file() and f.suffix in SUPPORTED_EXTENSIONS]
    return scripts

def run_script(script_path):
    """Run a specific script."""
    _, ext = os.path.splitext(script_path)
    if ext == ".sh":
        command = ["bash", str(script_path)]
    elif ext == ".py":
        command = ["python3", str(script_path)]
    else:
        print(f"Error: Unsupported script type '{ext}'.")
        return

    try:
        print(f"Running: {script_path}")
        result = subprocess.run(command, text=True, check=True, capture_output=True)
        print(result.stdout)
    except subprocess.CalledProcessError as e:
        print(f"Error executing {script_path}: {e.stderr}")

def tui_subdirectory_navigation(base_dir):
    """Navigate through subdirectories recursively and run scripts."""
    while True:
        # Discover all subdirectories at the current level
        subdirs = discover_subdirectories(base_dir)
        subdir_choices = [subdir.name for subdir in subdirs] + ["Back"] + ["Exit"]

        selected_subdir = questionary.select(
            f"Select a subdirectory in '{Path(base_dir).name}':",
            choices=subdir_choices
        ).ask()

        if selected_subdir == "Back":
            return  # Exit to the previous level
        if selected_subdir == "Exit":
            print("Exiting...")
            sys.exit(0)
        # Get the full path of the selected subdirectory
        selected_subdir_path = next(subdir for subdir in subdirs if subdir.name == selected_subdir)

        # Discover scripts or subdirectories in the selected subdirectory
        subdir_items = discover_subdirectories(selected_subdir_path)
        if subdir_items:
            # If there are further subdirectories, navigate deeper
            tui_subdirectory_navigation(selected_subdir_path)
        else:
            # Otherwise, list scripts in this directory
            scripts = discover_scripts_in_subdirectory(selected_subdir_path)
            if scripts:
                script_choices = [script.name for script in scripts] + ["Back to Parent Directory"]
                selected_script = questionary.select(
                    f"Select a script to run in '{selected_subdir_path.name}':",
                    choices=script_choices
                ).ask()

                if selected_script == "Back to Parent Directory":
                    return  # Go back to the parent directory

                # Step 3: Confirm and run the selected script
                confirm = questionary.confirm(f"Do you want to run '{selected_script}'?").ask()
                if confirm:
                    script_path = next(script for script in scripts if script.name == selected_script)
                    run_script(script_path)
                else:
                    print("Cancelled. Returning to subdirectory menu.")
            else:
                print(f"No scripts found in '{selected_subdir_path.name}'. Returning to parent subdirectory.")

def tui_main():
    """Main loop for the TUI."""
    while True:
        # Discover subdirectories at the root level
        subdirs = discover_subdirectories(BASE_DIR)
        main_menu_choices = [subdir.name for subdir in subdirs] + ["Exit"]

        selected_option = questionary.select(
            "Select an option:",
            choices=main_menu_choices
        ).ask()

        if selected_option == "Exit":
            print("Exiting...")
            sys.exit(0)

        # Get the full path of the selected subdirectory
        selected_subdir_path = next(subdir for subdir in subdirs if subdir.name == selected_option)

        # Navigate into the selected subdirectory
        tui_subdirectory_navigation(selected_subdir_path)

if __name__ == "__main__":
    tui_main()

