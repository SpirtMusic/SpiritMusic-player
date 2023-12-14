import QtQuick 2.15
import QtQuick.Controls 2.15
import QtMultimedia
import QtQuick.Dialogs
import QtQuick.Layouts 1.3
import QMpv 1.0
Rectangle {
    id: videoPlayerWindow
    visible: false
    color: "#00ffffff"
    anchors.fill: parent
    property MPV player: player
    property real recWidth: columnLayout.implicitHeight

    readonly property int android_SCREEN_ORIENTATION_LANDSCAPE: 0
    readonly property int android_SCREEN_ORIENTATION_PORTRAIT: 1

    property int currentOrientation: android_SCREEN_ORIENTATION_PORTRAIT

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
        function toggleOrientation() {
            if (currentOrientation === android_SCREEN_ORIENTATION_PORTRAIT) {
                androidUtils.rotateToLandscape();
                rotateBtn.icon.source="qrc:/qml/icons/cil-mobile.svg"
                currentOrientation = android_SCREEN_ORIENTATION_LANDSCAPE;
            } else {
                androidUtils.rotateToPortrait();
                rotateBtn.icon.source="qrc:/qml/icons/cil-mobile-landscape.svg"
                currentOrientation = android_SCREEN_ORIENTATION_PORTRAIT;
            }
        }
        function secondsToTimeString(durationInSeconds) {
            var hours = Math.floor(durationInSeconds / 3600);
            var minutes = Math.floor((durationInSeconds % 3600) / 60);
            var seconds = Math.floor(durationInSeconds % 60);

            hours = (hours < 10) ? "0" + hours : hours;
            minutes = (minutes < 10) ? "0" + minutes : minutes;
            seconds = (seconds < 10) ? "0" + seconds : seconds;

            return hours + ":" + minutes + ":" + seconds;
        }
    }
    Popup {
        id:popUpAboutVideo
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        rightMargin:20
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
        modal: true

        contentWidth: view.implicitWidth
        contentHeight: view.implicitHeight
        ScrollView{
            id: view
            anchors.fill: parent
            //    contentWidth: aboutvideoLabel.implicitWidth
            //     contentHeight: aboutvideoLabel.implicitHeight
            TextArea{
                id:aboutvideoLabel
                text:win.currentVideoDesc
                wrapMode: TextArea.WordWrap // Allow text to wrap to new lines
                width: view.width // Set the width of the TextArea to the width of the ScrollView
                height: view.height // Set the height of the TextArea to the height of the ScrollView

                readOnly: true // Make the TextArea non-editable
                selectByMouse: false // Disable text selection



                anchors.top: parent.top
                anchors.left: parent.left
                anchors.right: parent.right
                anchors.bottom: parent.bottom

            }
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
    Item {
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        ToolTip {
            id:infoTollTip
            timeout: 1000
        }
    }
    MPV {
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
                infoTollTip.show("PreserveAspectCrop")
                break
            case VideoOutput.PreserveAspectCrop:
                player.fillMode = VideoOutput.PreserveAspectFit
                infoTollTip.show("PreserveAspectFit")
                break
            case VideoOutput.PreserveAspectFit:
                player.fillMode = VideoOutput.Stretch
                infoTollTip.show("Stretch")
                break
            default:
                player.fillMode = VideoOutput.Stretch
                infoTollTip.show("Stretch")
            }
            console.log(player.fillMode)
        }
        function updatePlaybackRate(delta) {
            // modify the playback rate by adding the delta value
            playbackRate += delta
            if (playbackRate > 1.5) {
                playbackRate = 1.5
            } else if (playbackRate < 0.5) {
                playbackRate = 0.5
            }
            infoTollTip.show("Speed: "+ playbackRate.toFixed(1)+"x")
        }
//        onErrorChanged: {
//            console.log("Video Error:", player.errorString)
//        }


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
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.leftMargin: 0
            anchors.topMargin: 0
            anchors.rightMargin: 0
            // anchors.fill: parent
            spacing: 2

            RowLayout {
                spacing: 10
                Layout.minimumWidth: parent.width // Set the minimum width to parent width
                Label {
                    text: videoInternal.secondsToTimeString(player.position)
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 20
                }

                Label {
                    text: videoInternal.secondsToTimeString(player.duration)
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
                    //enabled: player.seekable
                    value: player.duration > 0 ? player.position / player.duration : 0
                    onMoved: function () {
                        player.position = player.duration * progressSlider.position
                    }
                    onPressedChanged: {
                        if(pressed){
                            console.log("pressed")
                            timeranimationMenu.stop()
                        }
                        else{
                            console.log("released")
                            timeranimationMenu.restart()
                        }
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
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                ToolButton {
                    id: rotateBtn
                    Layout.alignment: Qt.AlignLeft
                    Layout.leftMargin: 30
                    onClicked: {
                        videoInternal.toggleOrientation()
                        timeranimationMenu.restart()
                    }

                }
                RowLayout {
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.fillWidth: true
                    Layout.minimumWidth: parent.width/2

                    ToolButton {
                        id: decreaseSpeed
                        Layout.alignment:  Qt.AlignLeft
                        icon.source: "qrc:/qml/icons/cil-chevron-double-left.svg"
                        onClicked:{
                            player.updatePlaybackRate(
                                        -0.1) // decrease the playback rate by 0.1
                            timeranimationMenu.restart()
                        }
                    }
                    ToolButton {
                        id: playPauseBtn
                        Layout.alignment: Qt.AlignHCenter
                        icon.source: "qrc:/qml/icons/cil-media-play.svg"

                        property bool isRotated: false // Flag to toggle rotation

                        onClicked: {
                            if (player.playbackState === MediaPlayer.PlayingState) {
                                player.pause()
                                timeranimationMenu.restart()
                            } else {
                                player.play()
                                timeranimationMenu.restart()
                            }

                            // Toggle rotation
                            isRotated = !isRotated

                            // Start the rotation animation
                            rotationAnimation.running = true
                        }

                        transform: Rotation {
                            origin.x: playPauseBtn.width / 2
                            origin.y: playPauseBtn.height / 2
                            angle: playPauseBtn.isRotated ? 180 : 0
                        }

                        SequentialAnimation {
                            id: rotationAnimation
                            running: false
                            loops: 1 // Set to -1 for infinite looping

                            PropertyAnimation {
                                target: playPauseBtn
                                property: "rotation"
                                to: playPauseBtn.isRotated ? 180 : 0
                                duration: 200 // Adjust the duration as per your preference
                                easing.type: Easing.InOutQuad
                            }
                        }

                    }
                    ToolButton {
                        id: increaseSpeed
                        Layout.alignment: Qt.AlignRight
                        onClicked: {
                            player.updatePlaybackRate(
                                        0.1) // increase the playback rate by 0.1
                            timeranimationMenu.restart()
                        }
                        icon.source: "qrc:/qml/icons/cil-chevron-double-right.svg"

                    }

                }

                ToolButton {
                    Layout.alignment: Qt.AlignRight
                    id:switchFillModeBtn
                    icon.source: "qrc:/qml/icons/cil-flip-to-front.svg"
                    onClicked:{
                        player.switchFillMode()
                        timeranimationMenu.restart()
                    }
                }


                ToolButton {
                    id:btn3
                    Layout.alignment: Qt.AlignRight
                    Layout.rightMargin: 20
                    icon.source:"qrc:/qml/icons/cil-options.svg"
                    onClicked: popUpAboutVideo.open()
                }
            }
        }
        height: recWidth + rotateBtn.implicitHeight

        PropertyAnimation {
            id: animationOpenMenu
            target: videoControl
            property: "height"
            running: false
            to: recWidth + rotateBtn.implicitHeight
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

    Component.onCompleted: {
        if (currentOrientation === android_SCREEN_ORIENTATION_PORTRAIT) {
            rotateBtn.icon.source="qrc:/qml/icons/cil-mobile-landscape.svg"
        } else {
            rotateBtn.icon.source="qrc:/qml/icons/cil-mobile.svg"
        }
    }
}
