import QtQuick

Rectangle {
    property double batteryPercent: 0.0

    clip: true
    color: "transparent"
    x: 230
    anchors.bottom: parent.bottom
    height: batteryPanelImg.height
    width: batteryPanelImg.implicitWidth * batteryPercent;

    Image {
        id: batteryPanelImg
        source: "../images/batterypanel.png"
        fillMode: Image.PreserveAspectFit
    }
}