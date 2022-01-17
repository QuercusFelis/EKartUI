import sys
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine, QmlElement
from lib.DashboardController import DashboardController

app = QGuiApplication([])
engine = QQmlApplicationEngine()
engine.load("ui/Main.qml")

dashController = DashboardController()
context = engine.rootContext()
context.setContextProperty("dashController", dashController)

if not engine.rootObjects():
        sys.exit(-1)
sys.exit(app.exec())