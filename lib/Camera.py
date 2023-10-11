from PySide6.QtCore import QObject, Property, Slot, Signal, pyqtSlot
from PySide6.QtQml import QmlElement, QmlSingleton
import os

class Backend(QObject):

    @pyqtSlot()
    def use_camera(self):
        # Run the detection model with the first camera source
        self.run_detection(source=0)

    @pyqtSlot()
    def use_back_camera(self):
        # Run the detection model with the second camera source
        self.run_detection(source=1)

    def run_detection(self, source):
        os.system(f"python detect.py --weights ./528Project/kittikaleov2-int8_320_edgetpu.tflite --img 320 --conf 0.25 --source {source}")

