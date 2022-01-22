import QtQuick
import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.DashboardController 1.0

Image {
	property bool open: true
	property bool tick: true

	source: "../images/centerpanel.png"
	fillMode: Image.PreserveAspectFit

	Speedometer {
		id: speedometer
		anchors.verticalCenterOffset: -40
	}

	MouseArea {
		id: openButton
		anchors.fill: parent
		onClicked: stateGroup.state = "default"
	}

	//States & Transitions
	StateGroup {
		id: centerPanelStateGroup
		state: open ? "open" : "closed"
		states: [
			State {
				name: "open"
				PropertyChanges {
					target: speedometer
					visible: !DashboardController.locked
					open: true
					}
				PropertyChanges {target: openButton; enabled: false}
			},
			State {
				name: "closed"
				PropertyChanges {
					target: speedometer
					visible: !DashboardController.locked
					open: false
				}
				PropertyChanges {target: openButton; enabled: true}
			}
		]
	}
}