import QtQuick
import QtQuick.Controls

CheckBox {
    id: control
    property color normalColor: "transparent"
    property color checkedColor: "#5CD900"
    property color hoverColor: "#2D3237"
    property color borderColor: "#245600"

    hoverEnabled: true
    focusPolicy: Qt.NoFocus  // Remove system focus outline

    indicator: Rectangle {
        implicitWidth: 14
        implicitHeight: 14
        border.color: control.borderColor
        radius: 4  // Rounded corners for a modern look
        y: parent.height / 2 - height / 2

        color: {
            if (control.checked && control.hovered) return Qt.darker(control.checkedColor, 1.2)
            if (control.checked) return control.checkedColor
            if (control.hovered) return control.hoverColor
            return control.normalColor
        }

        Behavior on color {
            ColorAnimation { duration: 150 }
        }

        Image {
            visible: control.checked
            source: "qrc:/images/check.svg"
            width: 12
            height: 12
            anchors.centerIn: parent
        }
    }

    contentItem: Text {
        text: control.text
        color: "white"
        font.family: defaultFontFamily
        font.pixelSize: 12
        leftPadding: control.indicator.width + 8
        verticalAlignment: Text.AlignVCenter
        opacity: control.enabled ? 1.0 : 0.3
    }

    background: Rectangle {
        color: "transparent"
    }
}
