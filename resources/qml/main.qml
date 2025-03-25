import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Dialogs 
import "." as Local

Item {
    id: root
    anchors.fill: parent

    // Font Loaders
    FontLoader { id: interBlack; source: "qrc:/fonts/Inter-Black.ttf" }
    FontLoader { id: interBlackItalic; source: "qrc:/fonts/Inter-BlackItalic.ttf" }
    FontLoader { id: interBold; source: "qrc:/fonts/Inter-Bold.ttf" }
    FontLoader { id: interBoldItalic; source: "qrc:/fonts/Inter-BoldItalic.ttf" }
    FontLoader { id: interExtraBold; source: "qrc:/fonts/Inter-ExtraBold.ttf" }
    FontLoader { id: interExtraBoldItalic; source: "qrc:/fonts/Inter-ExtraBoldItalic.ttf" }
    FontLoader { id: interExtraLight; source: "qrc:/fonts/Inter-ExtraLight.ttf" }
    FontLoader { id: interExtraLightItalic; source: "qrc:/fonts/Inter-ExtraLightItalic.ttf" }
    FontLoader { id: interItalic; source: "qrc:/fonts/Inter-Italic.ttf" }
    FontLoader { id: interLight; source: "qrc:/fonts/Inter-Light.ttf" }
    FontLoader { id: interLightItalic; source: "qrc:/fonts/Inter-LightItalic.ttf" }
    FontLoader { id: interMedium; source: "qrc:/fonts/Inter-Medium.ttf" }
    FontLoader { id: interMediumItalic; source: "qrc:/fonts/Inter-MediumItalic.ttf" }
    FontLoader { id: interRegular; source: "qrc:/fonts/Inter-Regular.ttf" }
    FontLoader { id: interSemiBold; source: "qrc:/fonts/Inter-SemiBold.ttf" }
    FontLoader { id: interSemiBoldItalic; source: "qrc:/fonts/Inter-SemiBoldItalic.ttf" }
    FontLoader { id: interThin; source: "qrc:/fonts/Inter-Thin.ttf" }
    FontLoader { id: interThinItalic; source: "qrc:/fonts/Inter-ThinItalic.ttf" }

    // Custom properties
    property color primaryBg: "#131313"
    property color secondaryBg: "#191D21"
    property color headerBg: "#272C32"
    property color borderColor: "#0A0B08"
    property color accentColor: "#5CD900"
    property string defaultFontFamily: "Inter"

    Rectangle {
        anchors.fill: parent
        color: primaryBg

        // Main Layout
        ColumnLayout {
            anchors.fill: parent
            spacing: -1

    
            // TitleBar
            Rectangle {
                Layout.fillWidth: true
                height: 29
                color: "#1F2328"
                border.color: borderColor

                MouseArea {
                    anchors.fill: parent
                    property point clickPos: "0,0"
                    onPressed: {
                        mainWindow.startWindowDrag()
                    }
                }

                RowLayout {
                    anchors.fill: parent
                    spacing: 10

                    Text {
                        text: "Velo Media Downloader"
                        color: "white"
                        font.family: defaultFontFamily
                        font.weight: Font.Bold
                        Layout.leftMargin: 10
                    }

                    Item { Layout.fillWidth: true }

                    Row {
                        Layout.alignment: Qt.AlignLeft
                        spacing: 20

                        Text { text: "File"; color: "white"; font.family: defaultFontFamily; font.capitalization: Font.AllUppercase; font.pixelSize: 10; font.weight: Font.Medium }
                        Text { text: "Edit"; color: "white"; font.family: defaultFontFamily; font.capitalization: Font.AllUppercase; font.pixelSize: 10; font.weight: Font.Medium }
                        Text { text: "Help"; color: "white"; font.family: defaultFontFamily; font.capitalization: Font.AllUppercase; font.pixelSize: 10; font.weight: Font.Medium }
                        Text { text: "Tool"; color: "white"; font.family: defaultFontFamily; font.capitalization: Font.AllUppercase; font.pixelSize: 10; font.weight: Font.Medium }
                    }
                    Item { Layout.preferredWidth: 8 }
                    Image {
                        source: "qrc:/images/close.svg"
                        Layout.rightMargin: 10
                        Layout.preferredWidth: 10
                        Layout.preferredHeight: 10

                        MouseArea {
                            anchors.fill: parent
                            onClicked: mainWindow.closeApp()
                        }
                    }
                }
            }

            // Header Section
            Rectangle {
                Layout.fillWidth: true
                height: 128
                color: headerBg
                border.color: borderColor

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 10
                    spacing: 4

                    // URL Input
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        TextField {
                            id: urlInput
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            placeholderText: "Enter URL"
                            placeholderTextColor: Qt.rgba(1, 1, 1, 0.6)
                            background: Rectangle {
                                color: primaryBg
                                border.color: borderColor
                            }
                            color: "white"
                            font.family: defaultFontFamily
                            verticalAlignment: Text.AlignVCenter
                            onTextChanged: {
                                if (text.indexOf("http") !== 0 && text.length > 0) {
                                    mainWindow.logQmlError("URLInput", "Invalid URL format")
                                }
                            }
                        }
                        
                        Local.CustomButton {
                            Layout.preferredHeight: 32
                            Layout.preferredWidth: 100
                            text: "Download"
                            onClicked: mainWindow.startDownload(urlInput.text)
                        }
                    }

                    // Progress Section
                    RowLayout {
                        Layout.fillWidth: true
                        visible: progressBar.value > 0 || statusText.text !== ""
                        
                        ProgressBar {
                            id: progressBar
                            Layout.fillWidth: true
                            from: 0
                            to: 100
                            value: 0
                            
                            background: Rectangle {
                                color: primaryBg
                                border.color: borderColor
                            }
                            
                            contentItem: Rectangle {
                                width: progressBar.visualPosition * parent.width
                                height: parent.height
                                color: accentColor
                            }
                        }
                        
                        Text {
                            id: statusText
                            color: "white"
                            font.family: defaultFontFamily
                            Layout.minimumWidth: 100
                            horizontalAlignment: Text.AlignRight
                        }
                        
                        Local.CustomButton {
                            text: "Cancel"
                            visible: progressBar.value > 0 && progressBar.value < 100
                            onClicked: mainWindow.cancelDownload()
                        }
                    }

                    // Format Options
                    RowLayout {
                        spacing: 8
                        // Video Options
                        RowLayout {
                            Local.CustomRadioButton {
                                id: videoRadio
                                checked: true
                                text: "Video"
                                ButtonGroup.group: formatGroup
                            }
                            Local.CustomCombobox {
                                id: videoQualityCombo
                                enabled: videoRadio.checked
                                model: ["1080p", "720p", "480p"]
                            }
                        }

                        // Audio Options
                        RowLayout {
                            Local.CustomRadioButton {
                                id: audioRadio
                                text: "Audio Format"
                                ButtonGroup.group: formatGroup
                            }
                            Local.CustomCombobox {
                                id: audioFormatCombo
                                enabled: audioRadio.checked
                                model: ["MP3", "WAV", "AAC"]
                            }
                        }
                        
                        ButtonGroup {
                            id: formatGroup
                        }
                    }

                    // Download Location
                    RowLayout {
                        Layout.fillWidth: true
                        spacing: 8
                        
                        Text {
                            text: "Download folder:"
                            color: "white"
                            font.family: defaultFontFamily
                            font.weight: Font.Medium
                            Layout.alignment: Qt.AlignVCenter
                        }
                        
                        TextField {
                            id: downloadPath
                            Layout.fillWidth: true
                            Layout.preferredHeight: 32
                            text: mainWindow.downloadPath
                            onTextChanged: {
                                if (text !== mainWindow.downloadPath)
                                    mainWindow.setDownloadPath(text)
                            }
                            background: Rectangle {
                                color: primaryBg
                                border.color: borderColor
                            }
                            color: "white"
                            font.family: defaultFontFamily
                            verticalAlignment: Text.AlignVCenter
                        }
                        
                        Local.CustomButton {
                            Layout.preferredHeight: 32
                            Layout.preferredWidth: 100
                            text: "Browse"
                            onClicked: folderDialog.open()
                        }
                    }
                }
            }

            // ListView Section
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#191D21"
                border.color: borderColor

                ColumnLayout {
                    anchors.fill: parent
                    spacing: 0

                    // ListView Header
                    Rectangle {
                        Layout.fillWidth: true
                        height: 29
                        color: secondaryBg
                        border.color: borderColor

                        Text {
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.left
                            anchors.leftMargin: 10
                            text: "Download History"
                            color: "white"
                            font.family: defaultFontFamily
                        }
                    }

                    // ListView
                    ListView {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        clip: true
                        model: mainWindow.getDownloads()

                        // Empty state
                        Item {
                            anchors.fill: parent
                            visible: parent.count === 0

                            ColumnLayout {
                                anchors.centerIn: parent
                                spacing: 4

                                Image {
                                    Layout.alignment: Qt.AlignHCenter
                                    width: 96
                                    height: 96
                                    sourceSize: Qt.size(96, 96)
                                    fillMode: Image.PreserveAspectFit
                                    source: "qrc:/images/empty.png"
                                }

                                Text {
                                    Layout.alignment: Qt.AlignHCenter
                                    text: "No downloads history"
                                    color: "#808080"
                                    font.family: defaultFontFamily
                                    font.pixelSize: 14
                                }
                            }
                        }

                        delegate: Rectangle {
                            width: parent.width
                            height: 65
                            color: primaryBg
                            border.color: borderColor

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 10
                                spacing: 10

                                Image {
                                    width: 46
                                    height: 46
                                    sourceSize: Qt.size(46, 46)
                                    fillMode: Image.PreserveAspectFit
                                    source: {
                                        let ext = modelData.filename.toLowerCase().split('.').pop()
                                        let audioExts = ['mp3', 'wav', 'aac', 'm4a', 'ogg']
                                        return audioExts.includes(ext) ? "qrc:/images/music.png" : "qrc:/images/vid.png"
                                    }
                                }

                                Column {
                                    Layout.fillWidth: true
                                    Text {
                                        text: modelData.filename
                                        color: "white"
                                        font.family: defaultFontFamily
                                    }
                                    Text {
                                        text: modelData.path
                                        color: "#808080"
                                        font.family: defaultFontFamily
                                    }
                                }

                                Local.CustomButton {
                                    text: "Open Location"
                                    onClicked: Qt.openUrlExternally(modelData.path)
                                }
                            }
                        }
                    }
                }
            }
        }
    }

    Connections {
        target: mainWindow
        
        function onProgressChanged(status, percent) {
            statusText.text = status
            progressBar.value = percent >= 0 ? percent : progressBar.value
        }

        function onDownloadsChanged() {
            downloadsListView.model = mainWindow.getDownloads()
        }
    }

    FolderDialog {
        id: folderDialog
        title: "Choose Download Location"
        currentFolder: downloadPath.text
        onAccepted: {
            mainWindow.setDownloadPath(selectedFolder)
            mainWindow.logQml("Download path changed to: " + selectedFolder)
        }
        onRejected: {
            mainWindow.logQml("Directory selection cancelled")
        }
    }

    Component.onCompleted: {
        mainWindow.logQml("QML UI loaded successfully")
    }
}