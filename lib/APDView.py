from PySide6.QtQml import qmlRegisterType
from PySide6.QtQuick import QQuickPaintedItem
from PySide6.QtCore import Slot
from PySide6.QtGui import QImage, QPainter
from lib.VideoThread import VideoThread

class APDView(QQuickPaintedItem):
	cameraFrame = None

	def __init__(self, parent=None):
		QQuickPaintedItem.__init__(self, parent)
		# create the video capture thread
		self.thread = VideoThread()
		# connect its signal to the update_image slot
		self.thread.frameChanged.connect(self.updateCameraFrame)
		self.destroyed.connect(self.thread.stop())
		# start the thread
		self.thread.start()
		
	@Slot(QImage)
	def updateCameraFrame(self, qimg):
		self.cameraFrame = qimg
		self.update()

	def paint(self, painter: QPainter) -> None:
		painter.drawImage(self.cameraFrame)

# Register as QML type
qmlRegisterType(APDView, "org.ekart.APDView", 1, 0, "APDView")