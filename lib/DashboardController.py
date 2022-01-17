import sys
from PySide6.QtCore import QObject, Slot

class DashboardController(QObject):
    testPlus = True #temp var used for test code
    rpm = 0
    batteryPercent = 0.0
    headlightsOn = False
    parked = True

    @Slot()
    def toggleHeadlights(self):
        self.headlightsOn = not(self.headlightsOn)
        if self.headlightsOn:
            print(">>>>>>>Headlights ON!")
        else:
            print(">>>>>>>Headlights OFF!")
                        
    @Slot()
    def toggleParked(self):
        self.parked = not(self.parked)
        if self.parked:
            print(">>>>>>>Parked!")
        else:
            print(">>>>>>>Unparked!")
        
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
            self.batteryPercent += 0.05
            self.rpm += 100
        else:
            self.batteryPercent -= 0.05
            self.rpm -= 100
                
        if self.batteryPercent >= 1:
            self.testPlus = False
        elif self.batteryPercent <= 0:
            self.testPlus = True