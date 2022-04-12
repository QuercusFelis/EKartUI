from PySide6.QtCore import Signal
from PySide6.QtCore import QThread
from PySide6.QtGui import QImage
from PySide6.QtCore import Qt

from multiprocessing.shared_memory import SharedMemory
import numpy as np
import time
import cv2

class VideoThread(QThread):
	frameChanged = Signal(bool)
	qframe = None

	def __init__(self):
		super().__init__()
		self._run_flag = True


	def run(self):
		try:
			#create a shared memory for reading the frame shape
			frame_shape_shm = SharedMemory(name="frame_shape")
			frame_shape = np.ndarray([3], buffer=frame_shape_shm.buf, dtype='i4')

			#create the shared memory for the frame buffer
			frame_buffer_shm = SharedMemory(name="frame_buffer")

			#create the framebuffer using the shm's memory
			frame_buffer = np.ndarray(frame_shape, buffer=frame_buffer_shm.buf, dtype='u1')

			# Retrieve new frames from frame_buffer and send them off to App
			while self._run_flag:
				#qframe = self.convert_cv_qt(frame_buffer)
				#self.frameChanged.emit(qframe)
				self.qframe = self.convert_cv_qt(frame_buffer)
				self.frameChanged.emit(self.qframe)
				time.sleep(0.02)
				#print("in run")
				#self.frameChanged.emit(True)
		except:
			print("ERROR: Unable to connect to APD via shared memory. Check that APD's detect.py is running.")


	def stop(self):
		"""Sets run flag to False and waits for thread to finish"""
		self._run_flag = False
		self.wait()
		
		
	def get_frame(self):
		return self.qframe


	def convert_cv_qt(self, cv_img):
		"""Convert from an opencv image to QPixmap"""
		rgb_image = cv2.cvtColor(cv_img, cv2.COLOR_BGR2RGB)
		h, w, ch = rgb_image.shape
		bytes_per_line = ch * w
		convert_to_Qt_format = QImage(rgb_image.data, w, h, bytes_per_line, QImage.Format_RGB888)
		p = convert_to_Qt_format.scaled(640, 480, Qt.KeepAspectRatio)
		return p
