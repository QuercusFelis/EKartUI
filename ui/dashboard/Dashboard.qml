import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Item {
	anchors.fill: parent
	//Speedometer
	Speedometer {
		id: speedometer
		anchors.horizontalCenter: parent.horizontalCenter
	}

	//Info panel
	Image {
		id: infoPanel
		width: infoPanel.implicitWidth
		height: infoPanel.implicitHeight
		anchors.verticalCenter: parent.verticalCenter
		source: "../images/infopanel.png"
		fillMode: Image.PreserveAspectFit
	}

	//Button panel
	ButtonPanel {
		id: buttonPanel
	}

	//Regenerative braking panel
	RegenPanel {
		id: regenPanel
		anchors.bottom: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
	}

	//Battery charge panel
	BatteryPanel {
		id: batteryPanel
		x: 230
		anchors.bottom: parent.bottom
	}

	//Tachometer
	Tachometer {
		id: tachometer
	}

	//States & Transitions
	StateGroup {
		id: stateGroup
		state: "default"
		states: [
			State {
				name: "default"
				PropertyChanges {
					target: speedometer
					open: true
					y: 0
				}
				PropertyChanges {target: buttonPanel; x: 597}
				PropertyChanges {target: tachometer; x: 560; y: 173}
				PropertyChanges {target: infoPanel; x: 0}
			},
			State {
				name: "camera"
				PropertyChanges {
					target: speedometer
					open: false
					y: -250
				}
				PropertyChanges {target: buttonPanel; x: 800}
				PropertyChanges {target: tachometer; x: 770; y: 370}
				PropertyChanges {target: infoPanel; x: -240}
			}
		]
		
		transitions: [
			Transition {
				ParallelAnimation {
					PropertyAnimation {
						target: speedometer
						property: "y"
						duration: 150
					}
					PropertyAnimation {
						target: infoPanel
						property: "x"
						duration: 150
					}
					PropertyAnimation {
						target: buttonPanel
						property: "x"
						duration: 150
					}
					PropertyAnimation {
						target: tachometer
						property: "x"
						duration: 150
					}
					PropertyAnimation {
						target: tachometer
						property: "y"
						duration: 150
					}
				}
				to: "*"
				from: "*"
			}
		]
	}

	//Updates Dashboard Periodically
	Timer {
		interval: 25;
		repeat: true;
		running: true;
		onTriggered: {
			dashController.update();
			speedometer.speed = dashController.getSpeed();
			tachometer.rpm = dashController.getRPM();
			batteryPanel.batteryPercent = dashController.getBatteryPercent();
			regenPanel.regenPercent = dashController.getBatteryPercent();
		}
	}
}