from PySide6.QtCore import *
from PySide6.QtWidgets import *
from PySide6.QtGui import QColor, QIcon

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        if not MainWindow.objectName():
            MainWindow.setObjectName(u"MainWindow")
        MainWindow.resize(1080, 720)

        self.centralwidget = QWidget(MainWindow)
        self.centralwidget.setObjectName(u"centralwidget")

        # Main layout with splitter
        self.main_layout = QHBoxLayout(self.centralwidget)
        self.main_layout.setContentsMargins(10, 10, 10, 10)
        self.main_layout.setSpacing(15)

        # Splitter for left (tree + buttons), center (output), and right (status) panels
        self.splitter = QSplitter(Qt.Horizontal, self.centralwidget)
        self.splitter.setObjectName(u"splitter")

        # Left: Vertical splitter for tree and buttons
        self.setup_left_panel()

        # Center: Script output area
        self.setup_center_panel()

        # Right: Script status (pass/fail)
        self.setup_right_panel()

        # Add splitter to main layout
        self.main_layout.addWidget(self.splitter)

        # Set initial splitter proportions
        self.splitter.setSizes([250, 600, 250])  # Left, center, right panel widths

        MainWindow.setCentralWidget(self.centralwidget)
        self.retranslateUi(MainWindow)

    def setup_left_panel(self):
        """Setup the left panel for the tree and buttons."""
        self.left_widget = QWidget(self.splitter)
        self.left_layout = QVBoxLayout(self.left_widget)
        self.left_layout.setSpacing(15)

        # Tree widget (scripts) without header label
        self.treeWidget = QTreeWidget(self.left_widget)
        self.treeWidget.setObjectName(u"treeWidget")
        self.treeWidget.setStyleSheet(self.get_tree_widget_style())
        self.treeWidget.setToolTip("Select a directory or script to execute.")
        self.treeWidget.setHeaderHidden(True)  # Remove the header label
        self.left_layout.addWidget(self.treeWidget)

        # Bottom buttons panel
        self.buttons_panel = QWidget(self.left_widget)
        self.buttons_layout = QVBoxLayout(self.buttons_panel)
        self.buttons_layout.setSpacing(10)

        self.complete_check_button = QPushButton("Complete Check", self.buttons_panel)
        self.complete_check_button.setStyleSheet(self.get_button_style())
        self.complete_check_button.setToolTip("Run all check scripts")
        self.buttons_layout.addWidget(self.complete_check_button)

        self.complete_fix_button = QPushButton("Complete Fix", self.buttons_panel)
        self.complete_fix_button.setStyleSheet(self.get_button_style())
        self.complete_fix_button.setToolTip("Run all fix scripts")
        self.buttons_layout.addWidget(self.complete_fix_button)

        self.left_layout.addWidget(self.buttons_panel)

    def setup_center_panel(self):
        """Setup the center panel for script output."""
        self.center_widget = QWidget(self.splitter)
        self.center_layout = QVBoxLayout(self.center_widget)
        self.center_layout.setContentsMargins(0, 0, 0, 0)
        self.center_layout.setSpacing(15)

        self.output_label = QLabel("Script Output:", self.center_widget)
        self.output_label.setStyleSheet("font-weight: bold; font-size: 16px;")
        self.center_layout.addWidget(self.output_label)

        self.output_display = QTextEdit(self.center_widget)
        self.output_display.setStyleSheet(self.get_text_edit_style())
        self.output_display.setReadOnly(True)
        self.center_layout.addWidget(self.output_display)

        # Buttons below the output area
        self.button_layout = QHBoxLayout()
        self.execute_button = QPushButton("Execute Script", self.center_widget)
        self.execute_button.setStyleSheet(self.get_button_style())
        self.execute_button.setToolTip("Execute the selected script")
        self.button_layout.addWidget(self.execute_button)

        self.exit_button = QPushButton("Exit", self.center_widget)
        self.exit_button.setStyleSheet(self.get_button_style())
        self.exit_button.setToolTip("Exit the application")
        self.button_layout.addWidget(self.exit_button)

        self.center_layout.addLayout(self.button_layout)

    def setup_right_panel(self):
        """Setup the right panel for script status."""
        self.right_widget = QWidget(self.splitter)
        self.right_layout = QVBoxLayout(self.right_widget)
        self.right_layout.setContentsMargins(0, 0, 0, 0)
        self.right_layout.setSpacing(15)

        self.status_label = QLabel("Script Status (Pass/Fail):", self.right_widget)
        self.status_label.setStyleSheet("font-weight: bold; font-size: 16px;")
        self.right_layout.addWidget(self.status_label)

        self.status_list = QListWidget(self.right_widget)
        self.status_list.setStyleSheet("""
            background-color: #FFFFFF;
            color: #333;
            font-size: 14px;
            border-radius: 5px;
            padding: 5px;
            border: 1px solid #D0D0D0;
        """)
        self.right_layout.addWidget(self.status_list)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Script Executor", None))

    def get_tree_widget_style(self):
        """Return style for the tree widget."""
        return """
            background-color: #FFFFFF;
            color: #333;
            border-radius: 5px;
            padding: 5px;
            font-size: 14px;
            border: 1px solid #D0D0D0;
        """

    def get_button_style(self):
        """Return button style with no colors."""
        return """
            QPushButton {
                font-size: 14px;
                border: 1px solid #D0D0D0;
                border-radius: 5px;
                padding: 12px;
                text-align: center;
                font-weight: bold;
            }
            QPushButton:hover {
                border: 1px solid #A0A0A0;
            }
            QPushButton:pressed {
                border: 1px solid #808080;
            }
        """

    def get_text_edit_style(self):
        """Return style for QTextEdit widget."""
        return """
            background-color: #FFFFFF;
            color: #333;
            border-radius: 5px;
            padding: 8px;
            font-size: 14px;
            border: 1px solid #D0D0D0;
        """

