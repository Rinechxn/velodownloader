// CustomButton.qml
import QtQuick
import QtQuick.Controls

Control {
    id: root
    property color normalColor: "#191D21"
    property color hoverColor: "#2D3237"
    property color pressedColor: "#3E444B"
    property color borderColor: "#0A0B08"
    property color textColor: "white"
    property int borderWidth: 1
    property int radius: 0
    property alias text: buttonText.text
    property bool containsMouse: mouseArea.containsMouse
    property bool pressed: mouseArea.pressed

    implicitWidth: 120
    implicitHeight: 40

    signal clicked()

    background: Rectangle {
        id: bg
        color: root.pressed ? root.pressedColor : 
               root.containsMouse ? root.hoverColor : root.normalColor
        border.color: root.borderColor
        border.width: root.borderWidth
        radius: root.radius

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    contentItem: Text {
        id: buttonText
        text: root.text
        color: root.textColor
        font.family: defaultFontFamily
        font.pixelSize: 12
        font.weight: Font.Medium
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        hoverEnabled: true
        onClicked: root.clicked()
    }
}