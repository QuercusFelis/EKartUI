import sys

#QT modules
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine

app = QGuiApplication([])
engine = QQmlApplicationEngine()
engine.load("qml/dashboard.qml")

if not engine.rootObjects():
        sys.exit(-1)
sys.exit(app.exec())