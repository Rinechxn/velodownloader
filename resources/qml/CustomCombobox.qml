// CustomComboBox.qml
import QtQuick
import QtQuick.Controls

ComboBox {
    id: control
    
    property color normalColor: "#191D21"
    property color borderColor: "#0A0B08"
    property color textColor: "white"
    property color dropdownBg: "#272C32"
    property color hoverColor: "#2D3237"
    property color pressedColor: "#3E444B"
    
    delegate: ItemDelegate {
        width: control.width
        height: 32
        
        contentItem: Text {
            text: modelData
            color: control.textColor
            font.family: defaultFontFamily
            font.pixelSize: 12
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }
        
        background: Rectangle {
            color: hovered ? control.hoverColor : "transparent"
            
            Behavior on color {
                ColorAnimation { duration: 150 }
            }
        }
        
        highlighted: control.highlightedIndex === index
    }
    
    indicator: Image {
        x: control.width - width - 8
        y: (control.height - height) / 2
        source: "qrc:/images/arrow-down.svg"  // Make sure to add this image to your resources
        sourceSize.width: 12
        sourceSize.height: 8
    }
    
    contentItem: Text {
        leftPadding: 8
        rightPadding: control.indicator.width + 12
        text: control.displayText
        font.family: defaultFontFamily
        font.pixelSize: 12
        color: control.textColor
        verticalAlignment: Text.AlignVCenter
        elide: Text.ElideRight
    }
    
    background: Rectangle {
        implicitWidth: 120
        implicitHeight: 32
        color: control.pressed ? control.pressedColor :
               control.hovered ? control.hoverColor : control.normalColor
        border.color: control.borderColor
        border.width: 1
        
        Behavior on color {
            ColorAnimation { duration: 150 }
        }
    }
    
    popup: Popup {
        y: control.height
        width: control.width
        padding: 1
        
        background: Rectangle {
            color: control.dropdownBg
            border.color: control.borderColor
            border.width: 1
        }
        
        contentItem: ListView {
            clip: true
            implicitHeight: contentHeight
            model: control.popup.visible ? control.delegateModel : null
            
            ScrollIndicator.vertical: ScrollIndicator {}
        }
    }
}