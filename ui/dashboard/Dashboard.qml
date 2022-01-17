import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Item {
    anchors.fill: parent
    //Speedometer
    Speedometer {
        id: speedometer
        anchors.horizontalCenter: parent.horizontalCenter
    }

    //Info panel
    Image {
        id: infoPanel
        width: infoPanel.implicitWidth
        height: infoPanel.implicitHeight
        anchors.verticalCenter: parent.verticalCenter
        source: "../images/infopanel.png"
        fillMode: Image.PreserveAspectFit
    }

    //Button panel
    ButtonPanel {
        id: buttonPanel
    }

    //Regenerative braking panel
    Image {
        id: regenPanel
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        source: "../images/regenpanel.png"
        fillMode: Image.PreserveAspectFit
        
        Rectangle {
        id: regenLeft
        clip: true
        color: "transparent"
        anchors.top: parent.top
        anchors.right: parent.horizontalCenter
        height: parent.height
        
        Image {
            id: regenLeftImg
            source: "../images/regenleft.png"
            fillMode: Image.PreserveAspectFit
            anchors.right: parent.right
            }
        }

        Rectangle {
        id: regenRight
        clip: true
        color: "transparent"
        anchors.top: parent.top
        anchors.left: parent.horizontalCenter
        height: parent.height
        
        Image {
            id: regenRightImg
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

    //Battery charge panel
    Rectangle {
        id: batteryPanel
        clip: true
        color: "transparent"
        x: 230
        anchors.bottom: parent.bottom
        height: batteryPanelImg.height

        Image {
            id: batteryPanelImg
            source: "../images/batterypanel.png"
            fillMode: Image.PreserveAspectFit
        }
    }

    //Tachometer
    Image {
        id: tachometer
        width: tachometer.implicitWidth
        height: tachometer.implicitHeight
        source: "../images/tachometerpanel.png"
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
        state: "default"
        states: [
            State {
                name: "default"
                PropertyChanges {
                    target: speedometer
                    open: true
                    y: 0
                }
                PropertyChanges {target: buttonPanel; x: 597}
                PropertyChanges {target: tachometer; x: 560; y: 173}
                PropertyChanges {target: infoPanel; x: 0}
            },
            State {
                name: "camera"
                PropertyChanges {
                    target: speedometer
                    open: false
                    y: -250
                }
                PropertyChanges {target: buttonPanel; x: 800}
                PropertyChanges {target: tachometer; x: 770; y: 370}
                PropertyChanges {target: infoPanel; x: -240}
            }
        ]
        
        transitions: [
            Transition {
                ParallelAnimation {
                    PropertyAnimation {
                        target: speedometer
                        property: "y"
                        duration: 150
                    }
                    PropertyAnimation {
                        target: infoPanel
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
            speedometer.speed = dashController.getSpeed();
            rpm.text = dashController.getRPM();
            batteryPanel.width = batteryPanelImg.implicitWidth * dashController.getBatteryPercent();
            regenLeft.width = regenLeftImg.implicitWidth * dashController.getBatteryPercent();
            regenRight.width = regenRightImg.implicitWidth * dashController.getBatteryPercent();
        }
    }
}