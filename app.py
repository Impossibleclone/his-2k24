import sys
from pathlib import Path
import subprocess
from PySide6.QtCore import *
from PySide6 import *
from PySide6.QtWidgets import *
from improved_ui import Ui_MainWindow  # Replace with your UI file name


class ScriptExecutorApp(QMainWindow, Ui_MainWindow):
    def __init__(self):
        super().__init__()
        self.setupUi(self)

        # Populate the tree with directories and scripts
        self.populate_tree()

        # Connect buttons
        self.execute_button.clicked.connect(self.execute_selected_script)
        self.exit_button.clicked.connect(self.close)

    def populate_tree(self):
        """Populate the QTreeWidget with directory structure."""
        base_dir = Path("./scripts/rhel/v9")  # Update this path to your scripts directory
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

    def execute_selected_script(self):
        """Execute the selected script and display output."""
        selected_item = self.treeWidget.currentItem()
        if not selected_item:
            self.output_display.setText("Error: No script selected.")
            return

        script_path = Path(selected_item.data(0, Qt.UserRole))
        if script_path.is_dir():
            self.output_display.setText("Error: Please select a script file, not a directory.")
            return

        if not script_path.suffix in {".sh", ".py"}:
            self.output_display.setText("Error: Unsupported script type. Only .sh and .py are allowed.")
            return

        try:
            # Execute script
            if script_path.suffix == ".sh":
                command = ["bash", str(script_path)]
            elif script_path.suffix == ".py":
                command = ["python3", str(script_path)]
            else:
                return 

            result = subprocess.run(command, text=True, check=True, capture_output=True)
            status = result.stdout
            self.output_display.setText(status)

            # Update script status
            # self.status_list.addItem(f"{script_path.name}: PASS")
            if "FAIL" in status : self.status_list.addItem(f"{script_path.name}: FAIL")  
            else :  self.status_list.addItem(f"{script_path.name}:PASS")
        except subprocess.CalledProcessError as e:
            self.output_display.setText(f"Error executing script:\n{e.stderr}")
            


if __name__ == "__main__":
    app = QApplication(sys.argv)
    window = ScriptExecutorApp()
    window.show()
    sys.exit(app.exec())

