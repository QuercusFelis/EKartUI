import QtQuick
//import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.DashboardController 1.0

Image {
	source: "../images/infopanel.png"
	fillMode: Image.PreserveAspectFit

	Image {
		source: "../images/team-logo.png"
		fillMode: Image.PreserveAspectFit
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.topMargin: 10
		anchors.leftMargin: 10
		width: 184
	}

	Button {
		id: park
		text: "Park"
		checked: DashboardController.parked
		anchors.bottom: parent.bottom
		anchors.left: parent.left
		anchors.bottomMargin: 2
		anchors.leftMargin: 15
		font.family: "Haettenschweiler"
		font.pixelSize: 50
		hoverEnabled: false
		onClicked: {
			DashboardController.setDirection("parked")
		}

		background: Rectangle {
			implicitWidth: 210
			implicitHeight: 210
			border.color: "#1a1a1a"
			border.width: 6
			radius: width * 0.5
			color: parent.checked ? "#ffb0b0" : "#f2f2f2"
		}
	}

	Text {
		id: credits
		text: "Credits:
Team Lead: Vani Kapoor
UI Design & Programming:
    Andie Groeling
APD System: Ryan Guidice
Programming: Ryan Guidice
    & Nikola Durand
Power System:
    David Neitenbach
    & Rico Barela
CAD & 3D Printing: Matt Gilmore
EIR Mentor: Doug Bartlett"
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.topMargin: 85
		anchors.leftMargin: 10
		width: 184
		color: "#000000"
		anchors.verticalCenter: parent.verticalCenter
		font.pixelSize: 19
		anchors.verticalCenterOffset: -10
		anchors.horizontalCenter: parent.horizontalCenter
		font.family: "Haettenschweiler"
	}

	//States & Transitions
	StateGroup {
		id: infoStateGroup
		state: DashboardController.state
		states: [
			State {
				name: "default"
				PropertyChanges {
					target: park
					visible: (!DashboardController.locked && 
						(DashboardController.atRest || DashboardController.parked))
				}
				PropertyChanges {target: credits; visible: false}
			},
			State {
				name: "settings"
				PropertyChanges {target: park; visible: false}
				PropertyChanges {target: credits; visible: true}
			},
			State {
				name: "locked"
				PropertyChanges {target: credits; visible: false}
			}
		]
	}
}
