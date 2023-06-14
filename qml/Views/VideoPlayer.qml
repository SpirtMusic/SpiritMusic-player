import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia
import QtQuick.Dialogs
import QtQuick.Layouts 1.3
Rectangle {
    id: videoPlayerWindow
    visible: false
    color: "#00ffffff"
    property Video player: player
    Video {
        id:player
        anchors.fill: parent
        // Other properties and settings for the video player
        function switchFillMode() {
            // switch the fill mode to the next value in the sequence
            switch (player.fillMode) {
            case VideoOutput.Stretch:
                player.fillMode = VideoOutput.PreserveAspectCrop
                break
            case VideoOutput.PreserveAspectCrop:
                player.fillMode = VideoOutput.PreserveAspectFit
                break
            case VideoOutput.PreserveAspectFit:
                player.fillMode = VideoOutput.Stretch
                break
            default:
                player.fillMode = VideoOutput.Stretch
            }
        }
    }
    GridLayout {
        rows: 1
        columns: 3
        Button {
            id: button1
            text: qsTr("Button 111")
            onClicked: {
                console.log("Button 2 clicked")
                internal.playMode()
                player.play()
            }
        }
        Button {
            id: tn2
            text: qsTr("open  ")
            onClicked: {
                console.log("Button 2 clicked")
                dlg.visible = true
            }
        }
    }
    FileDialog {
        id: dlg
        //  nameFilters: [ "Video files (*.mp4 *.flv *.ts *.mpg *.3gp *.ogv *.m4v *.mov)", "All files (*)" ]
        title: "Please choose a video file"
        modality: Qt.WindowModal
        onAccepted: {
            console.log(dlg.currentFile)
            player.source = dlg.currentFile
            return
        }
        onRejected: {
            console.log("Canceled")
            return
        }
    }

    Rectangle {
        id: videoControl
        //  height: parent.width/7
        color: "#ffffff"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.bottomMargin: 0
        gradient: Gradient {
            GradientStop { position: 0; color: "transparent" }
            GradientStop { position: 1; color: "black" }
        }
        ColumnLayout {
            id: columnLayout
            spacing: 2
            anchors.fill: parent
            RowLayout {
                spacing: 10
                Layout.minimumWidth: parent.width // Set the minimum width to parent width
                Label {
                    text: "Label 1"
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20
                }

                Label {
                    text: "Label 2"
                    Layout.alignment: Qt.AlignRight

                    Layout.rightMargin: 20
                }
            }

            RowLayout {
                spacing: 10
                Layout.alignment: Qt.AlignHCenter
                Rectangle {
                    width: 20
                    height: 1
                    color: "transparent"
                    Layout.preferredWidth: 20
                }

                Slider {
                    // Slider properties
                    Layout.fillWidth: true
                }

                Rectangle {
                    width: 20
                    height: 1
                    color: "transparent"
                    Layout.preferredWidth: 20
                }
            }

            RowLayout {

                Layout.fillWidth: true
                Layout.minimumWidth: parent.width
                RowLayout {
                    Layout.fillWidth: true
                    Layout.minimumWidth: parent.width/2
                    ToolButton {
                        id: playPauseBtn
                        Layout.alignment: Qt.AlignRight
                        icon.source: "qrc:/qml/icons/cil-media-play.svg"
                    }
                }
                ToolButton {
                    Layout.alignment: Qt.AlignRight
                    id:switchFillModeBtn
                    icon.source: "qrc:/qml/icons/cil-flip-to-front.svg"
                    onClicked: player.switchFillMode()
                }


                ToolButton {
                    id:btn3
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 20
                    icon.source:"qrc:/qml/icons/cil-options.svg"

                }

            }
        }
        height: columnLayout.implicitHeight
    }
}
