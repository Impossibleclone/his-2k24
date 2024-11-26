
import sys
import subprocess
from pathlib import Path
from PySide6.QtCore import *
from PySide6.QtWidgets import *
from improved_ui3 import Ui_MainWindow  # Assuming this is your UI file
import logging

# Setup logging for better tracking
logging.basicConfig(level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

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
        self.complete_check_button.clicked.connect(lambda: self.run_scripts_by_keyword("chk"))
        self.complete_fix_button.clicked.connect(lambda: self.run_scripts_by_keyword("rem"))

    def populate_tree(self):
        """Populate the QTreeWidget with directory structure."""
        base_dir = self.get_base_directory()
        if not base_dir.exists():
            self.output_display.setText(f"Error: Directory '{base_dir}' not found.")
            return

        self.treeWidget.clear()
        root_item = QTreeWidgetItem(self.treeWidget)
        root_item.setText(0, base_dir.name)
        root_item.setData(0, Qt.UserRole, str(base_dir))
        self.add_items_to_tree(root_item, base_dir)
        self.treeWidget.expandAll()

        # Enable multi-selection in the tree widget
        self.treeWidget.setSelectionMode(QAbstractItemView.MultiSelection)

    def get_base_directory(self):
        """Return the base directory for scripts (can be customized)."""
        return Path("./scripts/ubuntu/v22.04")

    def add_items_to_tree(self, parent_item, path):
        """Recursively add items to the tree."""
        for item in sorted(path.iterdir()):
            tree_item = QTreeWidgetItem(parent_item)
            tree_item.setText(0, item.name)
            tree_item.setData(0, Qt.UserRole, str(item))  # Store full path for later use
            if item.is_dir():
                self.add_items_to_tree(tree_item, item)  # Recursively add subdirectories

    def execute_selected_scripts(self):
        """Execute the selected scripts or scripts from selected folders."""
        selected_items = self.treeWidget.selectedItems()
        if not selected_items:
            self.output_display.setText("Error: No script or folder selected.")
            return

        scripts_to_execute = []
        for item in selected_items:
            path = Path(item.data(0, Qt.UserRole))
            if path.is_dir():
                scripts_to_execute.extend(self.get_scripts_in_folder(path))
            elif path.is_file() and path.suffix in {".sh", ".py"}:
                scripts_to_execute.append(path)

        if not scripts_to_execute:
            self.output_display.setText("Error: No valid scripts selected.")
            return

        # Execute all selected scripts
        self.run_scripts(scripts_to_execute)

    def run_scripts(self, scripts_to_execute):
        """Run all selected scripts."""
        for script in scripts_to_execute:
            self.execute_script(script)

    def execute_script(self, script_path):
        """Run the specified script and update the output display."""
        if not script_path.suffix in {".sh", ".py"}:
            self.output_display.append(f"Error: Unsupported script type for {script_path.name}.")
            return

        # Execute script in background using QThread
        self.run_script_in_thread(script_path)

    def run_script_in_thread(self, script_path):
        """Run script in a separate thread to avoid UI blocking."""
        worker = ScriptWorker(script_path)
        worker.finished.connect(lambda: self.handle_script_output(worker))
        worker.start()

    def handle_script_output(self, worker):
        """Handle the output from a script execution."""
        output, script_path = worker.result
        self.output_display.append(output)
        status = f"{script_path.name}: {'PASS' if 'FAIL' not in output else 'FAIL'}"
        self.status_list.addItem(status)

    def get_scripts_in_folder(self, folder_path):
        """Return all scripts within a folder, recursively."""
        scripts = []
        for item in folder_path.rglob('*'):
            if item.is_file() and item.suffix in {".sh", ".py"}:
                scripts.append(item)
        return scripts

    def run_scripts_by_keyword(self, keyword):
        """Run scripts that contain a specific keyword in their name."""
        scripts = self.get_scripts_by_name(keyword)
        if scripts:
            self.run_scripts(scripts)
        else:
            self.output_display.append(f"No scripts found for '{keyword}'.")

    def get_scripts_by_name(self, filter_text):
        """Get all scripts that contain the filter_text in their filename."""
        base_dir = self.get_base_directory()
        scripts = []

        if base_dir.exists():
            for item in base_dir.rglob('*'):
                if item.is_file() and filter_text in item.name:
                    scripts.append(item)
        return scripts

    def get_input_from_user(self, prompt):
        """Display a dialog for user input."""
        text, ok = QInputDialog.getText(self, 'Input Required', prompt)
        if ok and text:
            return text
        return None


class ScriptWorker(QThread):
    """Worker thread to run scripts in the background."""
    finished = Signal()

    def __init__(self, script_path):
        super().__init__()
        self.script_path = script_path
        self.result = ("", script_path)

    def run(self):
        """Run the script and capture its output."""
        try:
            command = ["bash", str(self.script_path)] if self.script_path.suffix == ".sh" else ["python3", str(self.script_path)]
            result = subprocess.run(command, text=True, capture_output=True, check=True)
            self.result = (result.stdout, self.script_path)
        except subprocess.CalledProcessError as e:
            self.result = (f"Error executing {self.script_path.name}:\n{e.stderr}\n{e.stdout}", self.script_path)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = ScriptExecutorApp()
    window.show()
    sys.exit(app.exec())

