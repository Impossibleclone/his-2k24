
from PySide6.QtCore import *
from PySide6.QtWidgets import *

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
        self.main_layout.setSpacing(10)

        # Splitter for left (tree + buttons), center (output), and right (status) panels
        self.splitter = QSplitter(Qt.Horizontal, self.centralwidget)
        self.splitter.setObjectName(u"splitter")

        # Left: Vertical splitter for tree and buttons
        self.left_widget = QWidget(self.splitter)
        self.left_layout = QVBoxLayout(self.left_widget)

        # Tree widget (scripts)
        self.treeWidget = QTreeWidget(self.left_widget)
        self.treeWidget.setObjectName(u"treeWidget")
        self.treeWidget.setHeaderLabel("Scripts")
        self.left_layout.addWidget(self.treeWidget)

        # Bottom buttons panel
        self.buttons_panel = QWidget(self.left_widget)
        self.buttons_layout = QVBoxLayout(self.buttons_panel)
        
        # Complete Check Button
        self.complete_check_button = QPushButton("Complete Check", self.buttons_panel)
        self.complete_check_button.setObjectName(u"complete_check_button")
        self.buttons_layout.addWidget(self.complete_check_button)

        # Complete Fix Button
        self.complete_fix_button = QPushButton("Complete Fix", self.buttons_panel)
        self.complete_fix_button.setObjectName(u"complete_fix_button")
        self.buttons_layout.addWidget(self.complete_fix_button)

        self.left_layout.addWidget(self.buttons_panel)

        # Center: Script output area
        self.center_widget = QWidget(self.splitter)
        self.center_layout = QVBoxLayout(self.center_widget)
        self.center_layout.setContentsMargins(0, 0, 0, 0)

        self.output_label = QLabel("Script Output:", self.center_widget)
        self.output_label.setObjectName(u"output_label")
        self.center_layout.addWidget(self.output_label)

        self.output_display = QTextEdit(self.center_widget)
        self.output_display.setObjectName(u"output_display")
        self.output_display.setReadOnly(True)
        self.center_layout.addWidget(self.output_display)

        # Buttons at the bottom of the center widget
        self.button_layout = QHBoxLayout()
        self.execute_button = QPushButton("Execute Script", self.center_widget)
        self.execute_button.setObjectName(u"execute_button")
        self.button_layout.addWidget(self.execute_button)

        self.exit_button = QPushButton("Exit", self.center_widget)
        self.exit_button.setObjectName(u"exit_button")
        self.button_layout.addWidget(self.exit_button)

        self.center_layout.addLayout(self.button_layout)

        # Right: Script status (pass/fail)
        self.right_widget = QWidget(self.splitter)
        self.right_layout = QVBoxLayout(self.right_widget)
        self.right_layout.setContentsMargins(0, 0, 0, 0)

        self.status_label = QLabel("Script Status (Pass/Fail):", self.right_widget)
        self.status_label.setObjectName(u"status_label")
        self.right_layout.addWidget(self.status_label)

        self.status_list = QListWidget(self.right_widget)
        self.status_list.setObjectName(u"status_list")
        self.right_layout.addWidget(self.status_list)

        # Add splitter to main layout
        self.main_layout.addWidget(self.splitter)

        # Set initial splitter proportions
        self.splitter.setSizes([180, 600, 300])  # Left, center, right panel widths

        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Script Executor", None))
