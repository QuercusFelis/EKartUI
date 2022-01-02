import QtQuick
import QtQuick.Window
import QtQuick.Controls
import QtQuick.Timeline 1.0

ApplicationWindow{
    id: window
    width: 800
    height: 400
    visible: true
    color: "#1a1a1a"

    flags: Qt.Diag
    Image {
        id: speedometer
        width: speedometer.implicitWidth
        height: speedometer.implicitHeight
        source: "images/speedpanel.png"
        layer.smooth: false
        antialiasing: false
        enabled: false
        smooth: true
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit

        Text {
            id: mph
            color: "#000000"
            text: qsTr("35")
            anchors.verticalCenter: parent.verticalCenter
            style: Text.Normal
            styleColor: "#000000"
            enabled: true
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: mphLabel
                color: "#000000"
                text: qsTr("mph")
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: -10
                enabled: true
                style: Text.Normal
                font.family: "Haettenschweiler"
                styleColor: "#000000"
            }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: stateGroup.state = "dashDefault"
        }
    }

    Image {
        id: flexPanel
        width: flexPanel.implicitWidth
        height: flexPanel.implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        source: "images/flexpanel.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: buttonPanel
        width: buttonPanel.implicitWidth
        height: buttonPanel.implicitHeight
        source: "images/flexpanel2.png"
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: batteryPanel
        x: 197
        y: 291
        width: batteryPanel.implicitWidth
        height: batteryPanel.implicitHeight
        anchors.bottom: parent.bottom
        source: "images/batterypanel.png"
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: regenPanel
        x: 662
        y: 220
        width: regenPanel.implicitWidth
        height: regenPanel.implicitHeight
        anchors.bottom: parent.bottom
        source: "images/regenpanel.png"
        anchors.bottomMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
    }

    Image {
        id: tachometer
        width: tachometer.implicitWidth
        height: tachometer.implicitHeight
        source: "images/tachometerpanel.png"
        fillMode: Image.PreserveAspectFit

        Text {
            id: rpm
            x: 110
            y: 103
            color: "#000000"
            text: qsTr("2450")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 60
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: rpmLabel
                text: qsTr("rpm")
                anchors.top: parent.bottom
                font.pixelSize: 34
                anchors.topMargin: -10
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Haettenschweiler"
            }
        }
    }

    StateGroup {
        id: stateGroup
        state: "camera"
        states: [
            State {
                name: "dashDefault"
                PropertyChanges {target: speedometer; y: 0}
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
                PropertyChanges {target: buttonPanel; x: 597}
                PropertyChanges {target: tachometer; x: 560; y: 173}
                PropertyChanges {target: flexPanel; x: 0}
            },
            State {
                name: "camera"
                PropertyChanges {target: speedometer; y: -250}
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
                PropertyChanges {target: buttonPanel; x: 800}
                PropertyChanges {target: tachometer; x: 770; y: 370}
                PropertyChanges {target: flexPanel; x: -240}
            }
        ]
        
        transitions: [
            Transition {
                id: transition
                ParallelAnimation {
                    PropertyAnimation {
                        target: speedometer
                        property: "y"
                        duration: 150
                    }
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
                    PropertyAnimation {
                        target: flexPanel
                        property: "x"
                        duration: 150
                    }
                    PropertyAnimation {
                        target: buttonPanel
                        property: "x"
                        duration: 150
                    }
                    PropertyAnimation {
                        target: tachometer
                        property: "x"
                        duration: 150
                    }
                    PropertyAnimation {
                        target: tachometer
                        property: "y"
                        duration: 150
                    }
                }
                to: "*"
               from: "*"
            }
        ]
    }

    Timer {
        interval: 3000
        repeat: true
        running: true
        onTriggered: {
            var states = ["dashDefault", "camera"]
            var index = (states.indexOf(stateGroup.state)+1) % states.length
            stateGroup.state = states[index]
        }
    }
}
