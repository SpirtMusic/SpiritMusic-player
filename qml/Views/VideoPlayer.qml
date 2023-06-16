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
    property real recWidth: columnLayout.implicitHeight
    QtObject {
        id: videoInternal
        function msToTimeString(duration) {
            var milliseconds = Math.floor(
                        (duration % 1000) / 100), seconds = Math.floor((duration / 1000) % 60), minutes = Math.floor((duration / (1000 * 60)) % 60), hours = Math.floor((duration / (1000 * 60 * 60)) % 24)

            hours = (hours < 10) ? "0" + hours : hours
            minutes = (minutes < 10) ? "0" + minutes : minutes
            seconds = (seconds < 10) ? "0" + seconds : seconds
            return hours + ":" + minutes + ":" + seconds //+ "." + milliseconds;
        }
    }
    MouseArea {
        id: clickPlace
        anchors.fill: parent
        onClicked:{

            if (player.playbackState == MediaPlayer.PlayingState
                && videoControl.height == 0) {
                animationOpenMenu.start()
                timeranimationMenu.restart()
            } else if (player.playbackState
                       == MediaPlayer.PlayingState)
            animationCloseMenu.start()
        }
    }
    Timer {
        id: timeranimationMenu
        interval: 3000
        running: false
        repeat: false
        onTriggered: {
            if (player.playbackState == MediaPlayer.PlayingState)
                animationCloseMenu.start()
        }
    }
    Video {
        id:player
        anchors.fill: parent
        // Other properties and settings for the video player
        onPlaybackStateChanged: {
            if (playbackState == MediaPlayer.PlayingState) {
                playPauseBtn.icon.source = "qrc:/qml/icons/cil-media-pause.svg"
            } else {
                playPauseBtn.icon.source = "qrc:/qml/icons/cil-media-play.svg"
            }
        }
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
                    text: videoInternal.msToTimeString(player.position)
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20
                }

                Label {
                    text: videoInternal.msToTimeString(player.duration)
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
                    id: progressSlider
                    Layout.fillWidth: true
                    enabled: player.seekable
                    value: player.duration > 0 ? player.position / player.duration : 0
                    onMoved: function () {
                        player.position = player.duration * progressSlider.position
                    }
                    onPressedChanged: {
                          if(pressed)
                              console.log("pressed")
                          else
                              console.log("released")
                      }
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
                        onClicked: {
                               internal.playMode()
                            if (player.playbackState == MediaPlayer.PlayingState) {
                                player.pause()

                            } else {
                                player.play()

                            }
                        }
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
        height: recWidth

        PropertyAnimation {
            id: animationOpenMenu
            target: videoControl
            property: "height"
            running: false
            to: recWidth
            duration: 200
            easing.type: Easing.Linear
        }
        PropertyAnimation {
            id: animationCloseMenu
            target: videoControl
            property: "height"
            running: false
            to: 0
            duration: 200
            easing.type: Easing.Linear
        }
    }
}
