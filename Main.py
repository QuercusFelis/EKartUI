import sys
from PySide6.QtGui import QGuiApplication, QFontDatabase
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtCore import QUrl
import lib.DashboardController
import lib.APDView
import lib.Camera
from lib.Camera import Backend
	
app = QGuiApplication([])

backend = Backend()

engine = QQmlApplicationEngine()
engine.rootContext().setContextProperty("Backend", backend)
engine.load(QUrl.fromLocalFile('ButtonPanel.qml'))

QFontDatabase.addApplicationFont("ui/fonts/Royal_Rumble_Haettenschweiler.ttf")
engine.load("ui/Main.qml")

if not engine.rootObjects():
	sys.exit(-1)
sys.exit(app.exec())
