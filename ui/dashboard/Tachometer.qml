import QtQuick

Image {
    property string rpm: "0"

    source: "../images/tachometerpanel.png"
    fillMode: Image.PreserveAspectFit

    Text {
        x: 110
        y: 103
        color: "#000000"
        text: rpm
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 60
        anchors.verticalCenterOffset: -10
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Haettenschweiler"

        Text {
            text: "rpm"
            anchors.top: parent.bottom
            font.pixelSize: 34
            anchors.topMargin: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"
        }
    }
}