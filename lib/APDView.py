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
		# start the threads
		self.thread.start()
		
	#@Slot(bool)
	@Slot(QImage)
	def updateCameraFrame(self, qimg):
		print("In updateCameraFrame()")
		self.update()
		self.updatePolish()
		self.cameraFrame = self.thread.get_frame()

	def paint(self, painter: QPainter) -> None:
		#print("in paint()")
		print("in paint - cameraFrame data: " + str(self.cameraFrame))
		painter.drawImage(0,0,self.cameraFrame)

# Register as QML type
qmlRegisterType(APDView, "org.ekart.APDView", 1, 0, "APDView")
