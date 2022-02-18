import QtQuick
//import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.DashboardController 1.0

Text {
	property bool open: true

	id: mph
	color: "#000000"
	text: DashboardController.speed
	anchors.verticalCenter: parent.verticalCenter
	styleColor: "#000000"
	anchors.horizontalCenter: parent.horizontalCenter
	font.family: "Haettenschweiler"

	Text {
		id: mphLabel
		text: "mph"
		anchors.top: parent.bottom
		anchors.horizontalCenter: parent.horizontalCenter
		anchors.topMargin: -10
		font.family: "Haettenschweiler"
		styleColor: "#000000"
	}

	Image {
		id: forward
		source: DashboardController.forward ? "../images/arrowselected.png" : "../images/arrow.png"
		fillMode: Image.PreserveAspectFit
		anchors.bottom: mph.top
		anchors.bottomMargin: -15
		anchors.horizontalCenter: parent.horizontalCenter
		visible: true

		MouseArea {
			anchors.fill: parent
			onClicked: DashboardController.setDirection("forward")
		}
	}

	Image {
		id: reverse
		source: DashboardController.reverse ? "../images/arrowselected.png" : "../images/arrow.png"
		fillMode: Image.PreserveAspectFit
		rotation: 180
		anchors.top: mphLabel.bottom
		anchors.horizontalCenter: parent.horizontalCenter

		MouseArea {
			anchors.fill: parent
			onClicked: {
				DashboardController.setDirection("reverse")
			}
		}
	}

	//States & Transitions
	StateGroup {
		id: unlockedStateGroup
		state: open ? "open" : "closed"
		states: [
			State {
				name: "open"
				PropertyChanges {
					target: mph
					font.pixelSize: 130
					anchors.verticalCenterOffset: -40
				}
				PropertyChanges {
					target: mphLabel
					font.pixelSize: 40
					color: "#000000"
				}
				PropertyChanges {
					target: forward
					visible: (!DashboardController.locked && 
						(DashboardController.atRest || DashboardController.forward))
				}
				PropertyChanges {
					target: reverse
					visible: (!DashboardController.locked && 
						(DashboardController.atRest || DashboardController.reverse))
				}
			},
			State {
				name: "closed"
				PropertyChanges {
					target: mph
					font.pixelSize: 50
					anchors.verticalCenterOffset: 121
				}
				PropertyChanges {
					target: mphLabel
					font.pixelSize: 0
					color: "#e6e6e6"
				}
				PropertyChanges {target: forward; visible: false}
				PropertyChanges {target: reverse; visible: false}
			}
		]

		transitions: [
			Transition {
				ParallelAnimation {
					PropertyAnimation {
						target: mph
						property: "anchors.verticalCenterOffset"
						duration: 150
					}
					PropertyAnimation {
						target: mph
						property: "font.pixelSize"
						duration: 150
					}
					PropertyAnimation {
						target: mphLabel
						property: "font.pixelSize"
						duration: 150
					}
					PropertyAnimation {
						target: mphLabel
						property: "color"
						duration: 150
					}
				}
				to: "*"
				from: "*"
			}
		]
	}
}
