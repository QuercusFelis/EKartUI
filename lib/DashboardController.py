from PySide6.QtCore import QObject, Property, Slot, Signal
from PySide6.QtQml import QmlElement, QmlSingleton

QML_IMPORT_NAME = "org.ekart.DashboardController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class DashboardController(QObject):
	testPlus = True #temp var used for test code
	rpmVal = 0
	batteryPercentage = 0.0
	direction = "parked"
	isHeadlightOn = False
	isLocked = True

	rpmChanged = Signal(int)
	battPercentChanged = Signal(float)
	directionChanged = Signal(str)
	lockedChanged = Signal(bool)

	def __init__(self, parent=None):
		QObject.__init__(self, parent)
		self.startTimer(100)

	def timerEvent(self, event):
		self.update()

	@Slot()
	def toggleHeadlight(self):
		self.isHeadlightOn = not(self.isHeadlightOn)
		if self.isHeadlightOn:
			print(">>>>>>>Headlights ON!")
		else:
			print(">>>>>>>Headlights OFF!")

	@Slot(str)
	def setDirection(self, state):
		if(self.rpmVal == 0):
			self.direction = state
			self.directionChanged.emit(state)
			print(">>>>>>>"+state)
						
	@Slot()
	def toggleLocked(self):
		if(self.getParked):
			self.isLocked = not(self.isLocked)
			self.lockedChanged.emit(self.isLocked)
			if self.isLocked:
				print(">>>>>>>locked!")
			else:
				print(">>>>>>>Unlocked!")
		
	@Slot(result=str)
	def getSpeed(self):
		return str(int(self.rpmVal/100))
		
	@Slot(result=str)
	def getRPM(self):
		return str(self.rpmVal)

	@Slot(result=float)
	def getBatteryPercent(self):
		return self.batteryPercentage

	@Slot(result=bool)
	def getForward(self):
		if(self.direction == "forward"):
			return True
		else:
			return False

	@Slot(result=bool)
	def getReverse(self):
		if(self.direction == "reverse"):
			return True
		else:
			return False

	@Slot(result=bool)
	def getParked(self):
		if(self.direction == "parked"):
			return True
		else:
			return False
	
	@Slot(result=bool)
	def getLocked(self):
		return self.isLocked
		
	#tempory test code
	def update(self):
		if self.testPlus:
			self.batteryPercentage += 0.05
		else:
			self.batteryPercentage -= 0.05

		if self.batteryPercentage >= 1:
			self.testPlus = False
			self.rpmVal = 2500
		elif self.batteryPercentage <= 0:
			self.testPlus = True
			self.rpmVal = 0

		self.rpmChanged.emit(self.rpmVal)
		self.battPercentChanged.emit(self.batteryPercentage)

	speed = Property(str, getSpeed, notify=rpmChanged)
	rpm = Property(str, getRPM, notify=rpmChanged)
	forward = Property(bool, getForward, notify=directionChanged)
	reverse = Property(bool, getReverse, notify=directionChanged)
	parked = Property(bool, getParked, notify=directionChanged)
	locked = Property(bool, getLocked, notify=lockedChanged)
	batteryPercent = Property(float, getBatteryPercent, notify=battPercentChanged)