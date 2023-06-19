import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.LocalStorage 2.0
import Qt5Compat.GraphicalEffects

import "qrc:/qml/Database.js" as DB
Item {
    property string selectedFilePath: ""
    property var loadedLibrary: []
    property color materialLightBlue: Material.color(Material.BlueGrey)
    property color overlayColor: Material.color(Material.Blue)
    QtObject {
        id: jsonOperator
        property string packName
        property int videoNumbers
        signal getVideosInfoFinished()
        function getInfopack(file){
            packName=""
            var data =  file.read()
            packName=data.Pack_name
            return JSON.stringify(data.Pack_name)
        }
        function getvideoNumbers(file)
        {
            videoNumbers=0
            var data =  file.read()
            var videonumbers = [];
            for(var i=0;i<data.videos.length;i++)
            {
                videoNumbers=videoNumbers+i
            }
            return videoNumbers
        }
        function getvidoesInfo(file)
        {
                       console.log("getvidoesInfo()")
            var data =  file.read()
            var vidoesInfo = [];
            for (var i = 0; i < data.videos.length; i++) {
                var video = data.videos[i]
                var videoInfo = {
                    vbaseName: video.vbaseName,
                    vName: video.vName,
                    desc: video.desc
                }
                vidoesInfo.push(videoInfo)
            }

            return vidoesInfo
        }
    }
    Connections {
        target: jsonOperator
        function onGetVideosInfoFinished(){
            // Handle the emitted signal
              console.log("onGetVideosInfoFinished()")
            win.switchToVideosView()
        }
    }
    property FileDialog libraryfileDialog: libraryfileDialog
    ListView {
        id: listView
        anchors.fill: parent
        spacing: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        model: ListModel {
            Component.onCompleted: {
                for (var i = 0; i < loadedLibrary.length; i++) {
                    append({
                               name: loadedLibrary[i].name,
                               path: loadedLibrary[i].path,
                               videosN: loadedLibrary[i].videosN
                           })
                }
            }
        }
        Layout.fillWidth: true
        delegate: Pane {

            id:delegateLibrary
            width: parent.width

            contentHeight:drow.implicitHeight
            Material.elevation: 2
            Material.background:  listView.currentIndex === index && mouseArea.pressed ? Material.Indigo: "#2a292f"
            //   color: listView.currentIndex === index && mouseArea.pressed ? materialLightBlue : "#2e2f30"
            //border.color: Material.LightBlue

            //anchors.left: parent.left




            height: drow.implicitHeight+20
            bottomPadding: 10
            topPadding: 10

            property int index: index
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                // Handle pressed event
                onPressed: {
                    // Set the ListView's currentIndex to the index of this item
                    listView.currentIndex = index
                }

                // Handle released event
                onReleased: {
                    // If the ListView's currentIndex matches the index of this item, consider it a click
                    if (listView.currentIndex === index) {
                        console.log("Clicked on:", name.replace(/^"(.*)"$/, "$1"))
                        JsonFile.name=path
                        win.videoList=jsonOperator.getvidoesInfo(JsonFile)
                          jsonOperator.getVideosInfoFinished()
                                console.log("onReleased()")

                    }
                }
                onPressAndHold: {
                    // Set the ListView's currentIndex to the index of this item
                    listView.currentIndex = index
                    // Perform the selection action for long-press
                    console.log("Long-pressed on:", name.replace(/^"(.*)"$/, "$1"))

                }

            }
            RowLayout {
                id:drow
                spacing: 20
                anchors.fill: parent
                Item {
                    Layout.alignment: Qt.AlignLeft
                    width: 48
                    height: 48
                    Layout.leftMargin: 20
                    Image {
                        id: iconBtn
                        source: "qrc:/qml/icons/music-library.png"
                        sourceSize.width: 48
                        sourceSize.height: 48
                        fillMode: Image.PreserveAspectFit
                    }
                    ColorOverlay {
                        anchors.fill: iconBtn
                        source: iconBtn
                        color: overlayColor
                        antialiasing: true
                    }
                }
                ColumnLayout {
                    spacing: 5

                    Label {
                        text: name.replace(/^"(.*)"$/, "$1")
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true

                    }

                    Label {
                        text: "Videos: " + videosN.toString()
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignLeft

                    }
                }
            }
        }
    }
    FileDialog {
        id: libraryfileDialog
        //  nameFilters: [ "Video files (*.mp4 *.flv *.ts *.mpg *.3gp *.ogv *.m4v *.mov)", "All files (*)" ]
        title: "Please choose a video file"
        modality: Qt.WindowModal
        onAccepted: {
            console.log("You chose: " + libraryfileDialog.currentFile)
            JsonFile.name = libraryfileDialog.currentFile
            var name =jsonOperator.getInfopack(JsonFile)
            var videon=jsonOperator.getvideoNumbers(JsonFile)
            selectedFilePath = libraryfileDialog.currentFile
            //        DB.dbInsert(name, selectedFilePath,videon)

            console.log("vidoesInfo"+jsonOperator.getvidoesInfo(JsonFile))
            return
        }
        onRejected: {
            console.log("Canceled")
            return
        }
    }
    Component.onCompleted: {
        DB.dbInit()
        DB.dbReadAll()
    }


}

