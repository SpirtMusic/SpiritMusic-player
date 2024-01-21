import QtQuick
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform
import QtQuick.LocalStorage 2.0
import Qt5Compat.GraphicalEffects
import Qt.labs.platform 1.1
import "qrc:/qml/Database.js" as DB
Item {
    property string selectedFilePath: ""
    property var loadedLibrary: []
    property color materialLightBlue: Material.color(Material.BlueGrey)
    property color overlayColor: Material.color(Material.Blue)
    property FileDialog libraryfileDialog: libraryfileDialog
    property ListModel libraryListModel: libraryListModel
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
            videoNumbers=data.videos.length
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
        function removeProjectName(url) {
            var index = url.lastIndexOf("%2F"); // Find the last occurrence of "%2F"
            if (index !== -1) {
                var newPath = url.substring(0, index + 3); // Keep %2F
                return newPath;
            }
            return url;
        }
        function removeFileNameFromPath(filePath) {
            // Find the last index of the forward slash
            var lastIndex = filePath.lastIndexOf('/');

            // If the forward slash is found, extract the substring up to that index
            if (lastIndex !== -1) {
                return filePath.substring(0, lastIndex + 1);
            }

            // If no forward slash is found, return the original path
            return filePath;
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

    ListView {
        id: listView
        anchors.fill: parent
        spacing: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        model: ListModel {
            id:libraryListModel
            function libraryListModelUpdate() {
                libraryListModel.clear()
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
            property bool holdPressed: false
            property bool showDelete: false
            property int index: index
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true

                // Handle pressed event
                onPressed: {
                    // Set the ListView's currentIndex to the index of this item
                    listView.currentIndex = index
                    console.log("onPressed on:", name.replace(/^"(.*)"$/, "$1"))
                    deleteRec.hideButton();
                    holdPressed=false
                }

                // Handle released event
                onReleased: {
                    // If the ListView's currentIndex matches the index of this item, consider it a click
                    if (listView.currentIndex === index&& !holdPressed) {
                        console.log("onReleased on:", name.replace(/^"(.*)"$/, "$1"))
                        JsonFile.name=path
                        console.log(path)
                        //       var newUrl = jsonOperator.removeFileNameFromPath(path);
                        if(Qt.platform.os === "android"){
                            win.currentPathPack =androidUtils.convertUriToPath(path)
                        }
                        else
                            win.currentPathPack =jsonOperator.removeFileNameFromPath(path);
                        win.videoList=jsonOperator.getvidoesInfo(JsonFile)
                        jsonOperator.getVideosInfoFinished()
                    }

                }
                onPressAndHold: {
                    // listView.currentIndex = index
                    holdPressed=true
                    deleteRec.showButton()
                    console.log("Long-pressed on:", name.replace(/^"(.*)"$/, "$1"))
                }

            }
            RowLayout  {
                id:drow
                spacing: 20
                anchors.fill: parent
                clip: true
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
            Rectangle{
                id:deleteRec
                height: parent.height
                color: "#00ffffff"
                anchors.right: parent.right
                anchors.rightMargin: 0
                width: 0
                clip:true
                ToolButton {
                    Material.accent: "red"
                    Material.background: "#2e2f30"
                    id:deleteBtn
                    icon.source: "qrc:/qml/icons/delete.png"
                    icon.color: "red"
                    Layout.alignment: Qt.AlignRight
                    text:"Delete"
                    onClicked: {
                        DB.dbDeleteRow(name)
                        DB.dbReadAll()
                        libraryListModel.libraryListModelUpdate()
                    }

                }
                Behavior on width {
                    NumberAnimation {
                        duration: 300  // Animation duration in milliseconds
                        easing.type: Easing.InOutQuad  // Easing type (optional)
                    }
                }

                function showButton() {
                    deleteRec.width = deleteBtn.implicitWidth
                    deleteRec.forceActiveFocus()
                }
                function hideButton() {
                    deleteRec.width = 0

                }
                onActiveFocusChanged: {
                    if (!activeFocus) {
                        hideButton()
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
        //fileMode: FileDialog.OpenFiles
        onAccepted: {
            //            console.log(libraryfileDialog.files)
            //            var projectFile= filterSngvFiles(libraryfileDialog.files)
            //            console.log(projectFile)

            //            JsonFile.name = projectFile
            //            var name =jsonOperator.getInfopack(JsonFile)
            //            var videon=jsonOperator.getvideoNumbers(JsonFile)

            //            selectedFilePath =projectFile
            //            console.log("selectedFilePath"+selectedFilePath)

            //            DB.dbInit()
            //            DB.dbInsert(name, selectedFilePath,videon)
            //            DB.dbReadAll()

            //            libraryListModel.libraryListModelUpdate()



            var projectFile= libraryfileDialog.currentFile
            JsonFile.name = projectFile
            var name =jsonOperator.getInfopack(JsonFile)
            var videon=jsonOperator.getvideoNumbers(JsonFile)

            selectedFilePath =projectFile
            DB.dbInit()
            DB.dbInsert(name, projectFile,videon)
            DB.dbReadAll()

            libraryListModel.libraryListModelUpdate()

            //            var path = libraryfileDialog.currentFile
            //            console.log("path "+path)
            //            var real_path=androidUtils.convertUriToPath(path)
            //            console.log("real_path "+real_path)

            return
        }
        onRejected: {
            console.log("Canceled")
            return
        }
        function filterSngvFiles(fileUrls) {
            for (var i = 0; i < fileUrls.length; i++) {
                var fileUrl = fileUrls[i].toString(); // Convert the object to a string
                var extension = ".sngv";
                var endIndex = fileUrl.lastIndexOf(extension);

                if (endIndex !== -1 && endIndex === fileUrl.length - extension.length) {
                    return fileUrl;
                }
            }

            return ""; // Return an empty string if no matching element is found
        }


    }
    Component.onCompleted: {
        //DB.dbRemove()
        DB.dbInit()
        DB.dbReadAll()
        libraryListModel.libraryListModelUpdate()
    }

}

