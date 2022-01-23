import QtQuick
import QtQuick.Window
import QtQuick.Controls
import "./dashboard"

ApplicationWindow{
	id: window
	width: 800
	height: 400
	visible: true
	color: "#1a1a1a"

	flags: Qt.Dialog

	Dashboard {}
}