import QtQuick
import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.DashboardController 1.0

Image {
	source: "../images/infopanel.png"
	fillMode: Image.PreserveAspectFit

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

	//States & Transitions
	StateGroup {
		id: infoStateGroup
		state: DashboardController.state
		states: [
			State {
				name: "default"
				PropertyChanges {target: park; visible: true}
			},
			State {
				name: "settings"
				PropertyChanges {target: park; visible: false}
			}
		]
	}
}