from PySide6.QtCore import QObject, Property, Slot, Signal
from PySide6.QtQml import QmlElement, QmlSingleton
from multiprocessing.shared_memory import SharedMemory

QML_IMPORT_NAME = "org.ekart.DashboardController"
QML_IMPORT_MAJOR_VERSION = 1

@QmlElement
@QmlSingleton
class DashboardController(QObject):
	testPlus = True #temp var used for test code
	erpmVal = 0
	rpmVal = 0
	# Pole pairs of motor - determined by counting number of poles inside motor
	pole_pairs = 6
	batteryPercentage = 0.0
	direction = "parked"
	dashState = "locked"
	isHeadlightOn = False
	# Set up shared memory with can_parse.py for getting ERPM data
	try:
		erpm_shm = SharedMemory(name="rpm")
		erpm_buffer = erpm_shm.buf
		current_shm = SharedMemory(name="current")
		current_buffer = current_shm.buf
		watt_hrs_shm = SharedMemory(name="watt_hr")
		watt_hrs_buffer = watt_hrs_shm.buf
		watt_hrs_charged_shm = SharedMemory(name="watt_hrs_charged")
		watt_hrs_charged_buffer = watt_hrs_charged_shm.buf
		v_in_shm = SharedMemory(name="v_in")
		v_in_buffer = v_in_shm.buf
	except:
		print("ERROR: Unable to connect to can_parse via shared memory. Check that can_parse.py is running.")
		rpmVal = "ERROR"
	rpmChanged = Signal(int)
	battPercentChanged = Signal(float)
	directionChanged = Signal(str)
	stateChanged = Signal(bool)

#Update Tick Functions
	def __init__(self, parent=None):
		QObject.__init__(self, parent)
		self.startTimer(25)		

	def timerEvent(self, event):
		self.update()


	def update(self):		
		#tempory test code
		# if self.testPlus:
			# self.batteryPercentage += 0.005
		# else:
			# self.batteryPercentage -= 0.005

		# if self.batteryPercentage >= 1:
			# self.testPlus = False
			# self.rpmVal = 2500
		# elif self.batteryPercentage <= 0:
			# self.testPlus = True
			# self.rpmVal = 0
		###################
		
		# Get RPM value
		self.erpmVal = int.from_bytes(self.erpm_buffer, byteorder='big')
		self.rpmVal = int(self.erpmVal / self.pole_pairs)
		
		# TEMPORARY - Set battery value for display for e-days
		self.batteryPercentage = 0.75 
		
		self.rpmChanged.emit(self.rpmVal)
		self.battPercentChanged.emit(self.batteryPercentage)


#Control Slots
	@Slot()
	def toggleHeadlight(self):
		self.isHeadlightOn = not(self.isHeadlightOn)
		if self.isHeadlightOn:
			print(">>>>>>>Headlights ON!")
		else:
			print(">>>>>>>Headlights OFF!")


#Information Property Slots
	@Slot(result=str)
	def getSpeed(self):
		# multiply motor rpm by gear ratio
		wheelrpm = (self.rpmVal*9)/30
		# wheel circumference (in miles) and (60 m/h)
		speed = round(wheelrpm * 0.0003866793 * 60)
		return str(speed)
		
	@Slot(result=str)
	def getRPM(self):
		return str(self.rpmVal)

	@Slot(result=float)
	def getBatteryPercent(self):
		return self.batteryPercentage


#Direction Property Slots
	@Slot(str)
	def setDirection(self, direction):
		if(self.rpmVal == 0 and not(self.getLocked())):
			self.direction = direction
			self.directionChanged.emit(direction)
			print(">>>>>>>"+direction)

	@Slot(result=bool)
	def getResting(self):
		if(self.rpmVal < 50):
			return True
		else:
			return False

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


#State Property Slots	
	@Slot(str)
	def setState(self, state):
		self.dashState = state
		self.stateChanged.emit(state)
		print(">>>>>>>"+state)

	@Slot(result=str)
	def getState(self):
		return self.dashState

	@Slot(result=bool)
	def getDefault(self):
		return self.dashState == "default"

	@Slot(result=bool)
	def getLocked(self):
		return self.dashState == "locked"


	#Information Properties
	speed = Property(str, getSpeed, notify=rpmChanged)
	rpm = Property(str, getRPM, notify=rpmChanged)
	batteryPercent = Property(float, getBatteryPercent, notify=battPercentChanged)

	#Direction Properties
	atRest = Property(bool, getResting, notify=rpmChanged)
	forward = Property(bool, getForward, notify=directionChanged)
	reverse = Property(bool, getReverse, notify=directionChanged)
	parked = Property(bool, getParked, notify=directionChanged)

	#State Properties
	state = Property(str, getState, setState, notify=stateChanged)
	default = Property(bool, getDefault, notify=stateChanged)
	locked = Property(bool, getLocked, notify=stateChanged)
