import QtQuick

Rectangle {
	property double batteryPercent: 0.0

	clip: true
	color: "transparent"
	height: batteryPanelImg.height
	width: batteryPanelImg.implicitWidth * batteryPercent;

	Image {
		id: batteryPanelImg
		source: "../images/batterypanel.png"
		fillMode: Image.PreserveAspectFit
	}
}