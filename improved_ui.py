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

        # Splitter for left, center, and right panels
        self.splitter = QSplitter(Qt.Horizontal, self.centralwidget)
        self.splitter.setObjectName(u"splitter")

        # Left: Tree widget (scripts)
        self.treeWidget = QTreeWidget(self.splitter)
        self.treeWidget.setObjectName(u"treeWidget")
        self.treeWidget.setHeaderLabel("Scripts")

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
        self.splitter.setSizes([180, 600, 300])  # Initial widths for left, center, right panels

        MainWindow.setCentralWidget(self.centralwidget)

        self.retranslateUi(MainWindow)

    def retranslateUi(self, MainWindow):
        MainWindow.setWindowTitle(QCoreApplication.translate("MainWindow", u"Script Executor", None))

