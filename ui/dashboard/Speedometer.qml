import QtQuick
import QtQuick.Timeline
import QtQuick.Controls

Image {
    source: "../images/speedpanel.png"
    fillMode: Image.PreserveAspectFit
    property string speed: "0"
    property bool open: true

    Text {
        id: mph
        color: "#000000"
        text: speed
        anchors.verticalCenter: parent.verticalCenter
        styleColor: "#000000"
        anchors.horizontalCenter: parent.horizontalCenter
        font.family: "Haettenschweiler"

        Text {
            id: mphLabel
            text: "mph"
            anchors.top: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.topMargin: -10
            font.family: "Haettenschweiler"
            styleColor: "#000000"
        }
    }

    MouseArea {
        anchors.fill: parent
        onClicked: stateGroup.state = "default"
    }

    //States & Transitions
    StateGroup {
        id: buttonStateGroup
        state: open ? "open" : "closed"
        states: [
            State {
                name: "open"
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
            },
            State {
                name: "closed"
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
            }
        ]

        transitions: [
            Transition {
                ParallelAnimation {
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
                }
                to: "*"
                from: "*"
            }
        ]
    }
}