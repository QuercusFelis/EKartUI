import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
import lib.DashboardController

app = QGuiApplication([])
engine = QQmlApplicationEngine()

engine.load("ui/Main.qml")

if not engine.rootObjects():
	sys.exit(-1)
sys.exit(app.exec())