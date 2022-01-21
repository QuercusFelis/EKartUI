import QtQuick
import org.ekart.DashboardController 1.0

Image {
	source: "../images/regenpanel.png"
	fillMode: Image.PreserveAspectFit
		
	Rectangle {
		clip: true
		color: "transparent"
		anchors.top: parent.top
		anchors.right: parent.horizontalCenter
		height: parent.height
		width: regenLeft.implicitWidth * DashboardController.batteryPercent
		
		Image {
			id: regenLeft
			source: "../images/regenleft.png"
			fillMode: Image.PreserveAspectFit
			anchors.right: parent.right
		}
	}

	Rectangle {
		clip: true
		color: "transparent"
		anchors.top: parent.top
		anchors.left: parent.horizontalCenter
		height: parent.height
		width: regenRight.implicitWidth * DashboardController.batteryPercent
		
		Image {
			id: regenRight
			source: "../images/regenright.png"
			fillMode: Image.PreserveAspectFit
			anchors.left: parent.left
		}
	}

	Image {
		anchors.top: parent.top
		anchors.horizontalCenter: parent.horizontalCenter
		source: "../images/regennub.png"
		fillMode: Image.PreserveAspectFit
	}
}