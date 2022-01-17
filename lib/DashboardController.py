from PySide6.QtCore import QObject, Slot

class DashboardController(QObject):
        testPlus = True
        rpm = 0
        batteryPercent = 50.0
        
        @Slot(result=str)
        def getSpeed(self):
                return str(int(self.rpm/100))
        
        @Slot(result=str)
        def getRPM(self):
                return str(self.rpm)

        @Slot(result=float)
        def getBatteryPercent(self):
                return self.batteryPercent
        
        #tempory test code
        @Slot()
        def update(self):
                if self.testPlus:
                        self.rpm += 50
                else:
                        self.rpm -= 50
                
                if self.rpm > 3500:
                        self.testPlus = False
                elif self.rpm <= 0:
                        self.testPlus = True