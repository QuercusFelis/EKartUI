import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from lib.DashboardController import DashboardController

app = QGuiApplication([])
engine = QQmlApplicationEngine()

context = engine.rootContext()
dashController = DashboardController(context)

engine.load("ui/Main.qml")

if not engine.rootObjects():
	sys.exit(-1)
sys.exit(app.exec())