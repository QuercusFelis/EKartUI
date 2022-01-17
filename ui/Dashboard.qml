import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Item {
    id: dashboard
    anchors.fill: parent
    //Speedometer
    Image {
        id: speedometer
        width: speedometer.implicitWidth
        height: speedometer.implicitHeight
        source: "images/speedpanel.png"
        anchors.horizontalCenterOffset: 0
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        fillMode: Image.PreserveAspectFit
        
        Text {
            id: mph
            color: "#000000"
            text: "35"
            anchors.verticalCenter: parent.verticalCenter
            style: Text.Normal
            styleColor: "#000000"
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: mphLabel
                color: "#000000"
                text: "mph"
                anchors.top: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin: -10
                style: Text.Normal
                font.family: "Haettenschweiler"
                styleColor: "#000000"
            }
        }
        
        MouseArea {
            anchors.fill: parent
            onClicked: {
                stateGroup.state = "dashDefault"
            }
        }
    }

    //Info panel
    Image {
        id: flexPanel
        width: flexPanel.implicitWidth
        height: flexPanel.implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        source: "images/flexpanel.png"
        fillMode: Image.PreserveAspectFit
    }

    //Button panel
    Image {
        id: buttonPanel
        width: buttonPanel.implicitWidth
        height: buttonPanel.implicitHeight
        source: "images/flexpanel2.png"
        fillMode: Image.PreserveAspectFit

        Button {
            text: "Camera"
            width: 60
            height: 60
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.topMargin: 10
            anchors.leftMargin: 10
            onClicked: stateGroup.state = "camera"
        }
    }

    //Battery charge panel
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

    //Regenerative braking panel
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

    //Tachometer
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
            text: "2450"
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 60
            anchors.verticalCenterOffset: -10
            anchors.horizontalCenter: parent.horizontalCenter
            font.family: "Haettenschweiler"

            Text {
                id: rpmLabel
                text: "rpm"
                anchors.top: parent.bottom
                font.pixelSize: 34
                anchors.topMargin: -10
                anchors.horizontalCenter: parent.horizontalCenter
                font.family: "Haettenschweiler"
            }
        }
    }

    //States & Transitions
    StateGroup {
        id: stateGroup
        state: "dashDefault"
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

    //Updates Dashboard Periodically
    Timer {
        interval: 25;
        repeat: true;
        running: true;
        onTriggered: {
            dashController.update();
            mph.text = dashController.getSpeed();
            rpm.text = dashController.getRPM();
        }
    }
}