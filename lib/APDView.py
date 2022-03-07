from PySide6.QtQml import qmlRegisterType
from PySide6.QtWidgets import QLabel
from PySide6.QtCore import QObject, Slot
from PySide6.QtGui import QPixmap
import VideoThread

class APDView(QObject):
	def __init__(self, parent=None):
		QObject.__init__(self, parent)
		# create the label that holds the image
		self.imageLabel = QLabel(self)
		# 4:3 aspect ratio scaled down to match the height of the screen
		self.imageLabel.resize(534, 400)
		# create the video capture thread
		self.thread = VideoThread()
		# connect its signal to the update_image slot
		self.thread.frameChanged(self.updateCameraFrame)
		self.destroyed.connect(self.thread.stop())
		# start the thread
		self.thread.start()
		
	@Slot(QPixmap)
	def updateCameraFrame(self, pixmap):
		self.imageLabel.setPixmap(pixmap)

# Register as QML type
qmlRegisterType(APDView, "org.ekart.APDView", 1, 0, "APDView")