import QtQuick
import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.APDView 1.0

Item {
	anchors.fill: parent
	//CenterPanel
	CenterPanel {
		id: centerpanel
		anchors.horizontalCenter: parent.horizontalCenter
	}

	//Info panel
	InfoPanel {
		id: infoPanel
		anchors.verticalCenter: parent.verticalCenter
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

	//Camera View

	APDView {
		id: APDView
		anchors.verticalCenter: parent.verticalCenter
		anchors.horizontalCenter: parent.horizontalCenter
	}

	//States & Transitions
	StateGroup {
		id: stateGroup
		state: "default"
		states: [
			State {
				name: "default"
				PropertyChanges {
					target: centerpanel
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
					target: centerpanel
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
						target: centerpanel
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
}