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
}
