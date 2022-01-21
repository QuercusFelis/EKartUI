import QtQuick
import org.ekart.DashboardController 1.0

Rectangle {
	clip: true
	color: "transparent"
	height: batteryPanelImg.height
	width: batteryPanelImg.implicitWidth * DashboardController.batteryPercent;

	Image {
		id: batteryPanelImg
		source: "../images/batterypanel.png"
		fillMode: Image.PreserveAspectFit
	}
}