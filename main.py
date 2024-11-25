import sys
from pathlib import Path
import subprocess
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from improved_ui import Ui_MainWindow  # Assuming this is your UI file

class ScriptExecutorApp(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

        # Populate the tree with directories and scripts
        self.populate_tree()

        # Connect buttons
        self.execute_button.clicked.connect(self.execute_selected_scripts)
        self.exit_button.clicked.connect(self.close)

        # Connect the new buttons for "Complete Check" and "Complete Fix"
        self.complete_check_button.clicked.connect(self.run_complete_check_scripts)
        self.complete_fix_button.clicked.connect(self.run_complete_fix_scripts)

    def populate_tree(self):
        """Populate the QTreeWidget with directory structure."""
        base_dir = Path("./scripts/ubuntu/v22.04")  # Update this path to your scripts directory
        if not base_dir.exists():
            self.output_display.setText(f"Error: Directory '{base_dir}' not found.")
            return

        def add_items(parent_item, path):
            for item in sorted(path.iterdir()):
                tree_item = QTreeWidgetItem(parent_item)
                tree_item.setText(0, item.name)
                tree_item.setData(0, Qt.UserRole, str(item))  # Store full path for later use

                if item.is_dir():
                    add_items(tree_item, item)  # Recursively add subdirectories

        self.treeWidget.clear()
        root_item = QTreeWidgetItem(self.treeWidget)
        root_item.setText(0, base_dir.name)
        root_item.setData(0, Qt.UserRole, str(base_dir))
        add_items(root_item, base_dir)
        self.treeWidget.expandAll()

        # Enable multi-selection in the tree widget
        self.treeWidget.setSelectionMode(QAbstractItemView.MultiSelection)

    def execute_selected_scripts(self):
        """Execute the selected scripts or scripts from selected folders."""
        selected_items = self.treeWidget.selectedItems()
        if not selected_items:
            self.output_display.setText("Error: No script or folder selected.")
            return

        # Collect all scripts from selected items (both files and folders)
        scripts_to_execute = []
        for item in selected_items:
            path = Path(item.data(0, Qt.UserRole))
            if path.is_dir():
                # If it's a folder, get all scripts within it
                scripts_to_execute.extend(self.get_scripts_in_folder(path))
            elif path.is_file() and path.suffix in {".sh", ".py"}:
                # If it's a valid script file, add it to the list
                scripts_to_execute.append(path)

        if not scripts_to_execute:
            self.output_display.setText("Error: No valid scripts selected.")
            return

        # Execute all selected scripts
        for script in scripts_to_execute:
            self.execute_script(script)

    def execute_script(self, script_path):
        """Run the specified script and update the output display."""
        if not script_path.suffix in {".sh", ".py"}:
            self.output_display.append(f"Error: Unsupported script type for {script_path.name}.")
            return

        # Choose the appropriate command based on script type
        if script_path.suffix == ".sh":
            command = ["bash", str(script_path)]
        elif script_path.suffix == ".py":
            command = ["python3", str(script_path)]

        try:
            # Execute script and capture output
            result = subprocess.run(command, text=True, check=True, capture_output=True)
            self.handle_script_output(result, script_path)
        except subprocess.CalledProcessError as e:
            self.output_display.append(f"Error executing {script_path.name}:\n{e.stderr}\n{e.stdout}")

    def handle_script_output(self, result, script_path):
        """Handle the output of a script execution."""
        status = result.stdout
        self.output_display.append(status)  # Append output to the display
        status_message = f"{script_path.name}: {'PASS' if 'FAIL' not in status else 'FAIL'}"
        self.status_list.addItem(status_message)

    def get_scripts_in_folder(self, folder_path):
        """Return all scripts within a folder, recursively."""
        scripts = []
        for item in folder_path.rglob('*'):
            if item.is_file() and item.suffix in {".sh", ".py"}:
                scripts.append(item)
        return scripts

    def run_complete_check_scripts(self):
        """Run all scripts that contain 'chk' in their name, sequentially."""
        scripts = self.get_scripts_by_name("chk")
        if scripts:
            for script in scripts:
                self.execute_script(script)
        else:
            self.output_display.append("No scripts found for 'chk'.")

    def run_complete_fix_scripts(self):
        """Run all scripts that contain 'rem' in their name, sequentially."""
        scripts = self.get_scripts_by_name("rem")
        if scripts:
            for script in scripts:
                self.execute_script(script)
        else:
            self.output_display.append("No scripts found for 'rem'.")

    def get_scripts_by_name(self, filter_text):
        """Get all scripts that contain the filter_text in their filename."""
        base_dir = Path("./scripts/ubuntu/v22")  # Update this path to your scripts directory
        scripts = []

        if base_dir.exists():
            for item in base_dir.rglob('*'):
                if item.is_file() and filter_text in item.name:
                    scripts.append(item)
        return scripts


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = ScriptExecutorApp()
    window.show()
    sys.exit(app.exec())

