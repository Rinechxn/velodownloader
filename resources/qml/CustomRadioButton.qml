// CustomRadioButton.qml
import QtQuick
import QtQuick.Controls

RadioButton {
    id: control
    property color checkedColor: "#5CD900"
    property color borderColor: "#245600"

    indicator: Rectangle {
        width: 12
        height: 12
        radius: 2
        border.color: control.borderColor
        border.width: 2
        color: control.checked ? control.checkedColor : "transparent"
        y: parent.height / 2 - height / 2

        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }

    contentItem: Text {
        text: control.text
        color: "white"
        font.family: defaultFontFamily
        font.weight: Font.Medium
        leftPadding: control.indicator.width + 1
        verticalAlignment: Text.AlignVCenter
    }
}