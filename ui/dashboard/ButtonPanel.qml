import QtQuick
//import QtQuick.Timeline
import QtQuick.Controls
import org.ekart.DashboardController 1.0

Image {
	readonly property int buttonSize: 65
	readonly property int buttonRadius: 15
	readonly property int outerMargin: 10
	readonly property int innerMargin: 5

	source: "../images/buttonpanel.png"
	fillMode: Image.PreserveAspectFit

	//Lights Toggle
	Button {
		id: lights
		text: "Lights"
		anchors.top: parent.top
		anchors.left: parent.left
		anchors.topMargin: outerMargin
		anchors.leftMargin: outerMargin
		font.family: "Haettenschweiler"
		font.pixelSize: 22
		hoverEnabled: false
		onClicked: {
			DashboardController.toggleHeadlight()
			checked = !checked
		}

		background: Rectangle {
			implicitWidth: buttonSize
			implicitHeight: buttonSize
			border.color: "#1a1a1a"
			border.width: 4
			radius: buttonRadius
			color: parent.checked ? "#ffb0b0" : "#f2f2f2"
		}
	}

	//Camera Button
	Button {
		id: camera
		text: "Camera"
		anchors.top: parent.top
		anchors.right: parent.right
		anchors.left: lights.right
		anchors.topMargin: outerMargin
		anchors.rightMargin: outerMargin
		anchors.leftMargin: innerMargin
		font.family: "Haettenschweiler"
		font.pixelSize: 22
		hoverEnabled: false
		onClicked: {
        Backend.use_camera()
        stateGroup.state = "camera"
    }
		background: Rectangle {
			implicitHeight: buttonSize
			border.color: "#1a1a1a"
			border.width: 4
			radius: buttonRadius
			color: parent.down ? "#c0c0c0" : "#f2f2f2"
		}
	}
	Button {
		id: backCamera
		text: "Reverse Camera"
		anchors.top: camera.bottom
		anchors.right: parent.right
		anchors.topMargin: innerMargin
		anchors.rightMargin: outerMargin
		anchors.leftMargin: outerMargin
		implicitWidth: DashboardController.parked ? buttonSize : 183
		implicitHeight: buttonSize
		font.family: "Haettenschweiler"
		font.pixelSize: 17
		hoverEnabled: false
		onClicked: {
			Backend.use_back_camera()
        	stateGroup.state = "backCamera"
		}

		background: Rectangle {
			implicitHeight: buttonSize
			border.color: "#1a1a1a"
			border.width: 4
			radius: buttonRadius
			color: parent.down ? "#c0c0c0" : "#f2f2f2"
		}


	}
	//Settings Button
	//Button {
	//	id: settings
	//	text: "Settings"
	//	anchors.top: backCamera.bottom
	//	anchors.right: parent.right
	//	anchors.topMargin: innerMargin
	//	anchors.rightMargin: outerMargin
	//	anchors.leftMargin: outerMargin
	//	implicitWidth: DashboardController.parked ? buttonSize : 183
	//	implicitHeight: buttonSize
	//	font.family: "Haettenschweiler"
	//	font.pixelSize: 17
	//	hoverEnabled: false
	//	onClicked: {
	//		DashboardController.state = "settings"
	//	}
	//
	//	background: Rectangle {
	//		anchors.fill: parent
	//		border.color: "#1a1a1a"
	//		border.width: 4
	//		radius: buttonRadius
	//		color: parent.down ? "#c0c0c0" : "#f2f2f2"
	//	}
//	}

	//Settings Button
//	Button {
//		id: lock
//		text: DashboardController.locked ? "Unlock" : "Lock"
//		checked: DashboardController.locked
//		anchors.top: camera.bottom
//		anchors.left: parent.left
//		anchors.topMargin: innerMargin
//		anchors.leftMargin: outerMargin
//		font.family: "Haettenschweiler"
//		font.pixelSize: 22
//		hoverEnabled: false
//		onClicked: {
//			if(checked) DashboardController.state = "default"
//			else DashboardController.state = "locked"
//		}
//
//		background: Rectangle {
//			implicitHeight: buttonSize
//			border.color: "#1a1a1a"
//			border.width: 4
//			radius: buttonRadius
//			color: parent.checked ? "#ffb0b0" : "#f2f2f2"
//		}
//	}

	//Back Button
	Button {
		id: back
		text: "Back"
		anchors.top: camera.bottom
		anchors.left: parent.left
		anchors.right: parent.right
		anchors.topMargin: innerMargin
		anchors.leftMargin: outerMargin
		anchors.rightMargin: outerMargin
		font.family: "Haettenschweiler"
		font.pixelSize: 22
		hoverEnabled: false
		onClicked: DashboardController.state = "default"

		background: Rectangle {
			implicitHeight: buttonSize
			border.color: "#1a1a1a"
			border.width: 4
			radius: buttonRadius
			color: parent.down ? "#c0c0c0" : "#f2f2f2"
		}
	}

	//States & Transitions
	StateGroup {
		id: buttonStateGroup
		state: DashboardController.state
		states: [
			State {
				name: "default"
				PropertyChanges {
					target: settings
					visible: true
				}
				PropertyChanges {target: back; visible: false}
				PropertyChanges {
					target: lock 
					visible: DashboardController.parked
					anchors.right: settings.left
					anchors.rightMargin: innerMargin
				}
			},
			State {
				name: "settings"
				PropertyChanges {target: settings; visible: false}
				PropertyChanges {target: back; visible: true}
				PropertyChanges {
					target: lock
					visible: false
					anchors.right: parent.right
				}
			},
			State {
				name: "locked"
				PropertyChanges {target: settings; visible: false}
				PropertyChanges {target: back; visible: false}
				PropertyChanges {
					target: lock
					visible: true
					anchors.right: parent.right
					anchors.rightMargin: outerMargin
				}
			}
		]
	}
}
