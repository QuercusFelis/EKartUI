import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Timeline 1.0

ApplicationWindow{
    id: window
    width: 800
    height: 400
    visible: true

    flags: Qt.Diag

    Image {
        id: speedpanel
        x: 213
        width: speedpanel.implicitWidth
        height: speedpanel.implicitHeight
        anchors.top: parent.top
        source: "images/speedpanel.png"
        layer.smooth: false
        antialiasing: false
        enabled: false
        smooth: true
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        sourceSize.height: 332
        sourceSize.width: 375
        fillMode: Image.PreserveAspectFit

        Text {
            id: speedometer
            x: 177
            y: 108
            color: "#5b0303"
            text: qsTr("35")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 100
            style: Text.Normal
            styleColor: "#000000"
            enabled: true
            anchors.verticalCenterOffset: -40
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: mph
                x: 0
                width: mph.contentWidth
                height: 34
                color: "#5b0303"
                text: qsTr("mph")
                anchors.top: parent.bottom
                font.pixelSize: 32
                anchors.topMargin: -11
                anchors.horizontalCenterOffset: 0
                enabled: true
                style: Text.Normal
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Haettenschweiler"
                styleColor: "#000000"
            }
        }
    }

    Image {
        id: flexpanel1
        y: 0
        width: flexpanel1.implicitWidth
        height: flexpanel1.implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        source: "images/flexpanel.png"
        anchors.leftMargin: 0
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: flexpanel2
        width: flexpanel2.implicitWidth
        height: flexpanel2.implicitHeight
        anchors.left: parent.left
        anchors.top: parent.top
        source: "images/flexpanel2.png"
        anchors.topMargin: 0
        anchors.leftMargin: 597
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: batterypanel
        x: 197
        y: 291
        width: batterypanel.implicitWidth
        height: batterypanel.implicitHeight
        anchors.bottom: parent.bottom
        source: "images/batterypanel.png"
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: regenpanel
        x: 662
        y: 220
        width: regenpanel.implicitWidth
        height: regenpanel.implicitHeight
        anchors.bottom: parent.bottom
        source: "images/regenpanel.png"
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: tachpanel
        x: 560
        y: 173
        width: tachpanel.implicitWidth
        height: tachpanel.implicitHeight
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        source: "images/tachometerpanel.png"
        anchors.bottomMargin: -13
        anchors.rightMargin: 0
        fillMode: Image.PreserveAspectFit

        Text {
            id: tachometer
            x: 110
            y: 103
            width: tachometer.contentWidth
            height: tachometer.contentHeight
            color: "#fdc7c7"
            text: qsTr("2450")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 60
            anchors.verticalCenterOffset: -13
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: rpm
                x: 0
                width: rpm.contentWidth
                height: 34
                color: "#fdc7c7"
                text: qsTr("rpm")
                anchors.top: parent.bottom
                font.pixelSize: 32
                anchors.topMargin: -11
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Haettenschweiler"
            }
        }
    }
}
