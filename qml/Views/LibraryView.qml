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
    id:libraryViewParent
    property string selectedFilePath: ""
    property var loadedLibrary: []
    property color materialLightBlue: Material.color(Material.BlueGrey)
    property color overlayColor: Material.color(Material.Blue)
    property FileDialog libraryfileDialog: libraryfileDialog
    property ListModel libraryListModel: libraryListModel
    property alias listView: listView
    property real optionToolBarHeight
    property Rectangle optionToolBar: optionToolBar
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

    BusyIndicator {
        id:loadingLibrary
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        running: false
        z:1
    }
    Rectangle {
        id: optionToolBar
        color: "#2a292f"
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.topMargin: 0
        property bool isOpened: false
        RowLayout {
            id: columnLayout2
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            spacing: 1
            anchors.leftMargin: 5
            anchors.bottomMargin: 0
            anchors.rightMargin: 5

            ToolButton {
                Material.accent: "red"
                Material.background: "#2e2f30"
                id:deleteBtn
                icon.source: "qrc:/qml/icons/delete.png"
                icon.color: "red"
                Layout.alignment: Qt.AlignRight
                text:"Delete"
                onClicked: {
                    var selectedIndexes = []

                    // Iterate over the model and find the selected items

                    for (var i = 0; i < libraryListModel.count; i++) {
                        var item = libraryListModel.get(i)
                        if (item.itemSelect) {
                            selectedIndexes.push(i)
                        }
                    }

                    // Delete the selected items from the model
                    for (var j = selectedIndexes.length - 1; j >= 0; j--) {
                        var index = selectedIndexes[j]
                        var currentName = libraryListModel.get(index).name
                        DB.dbDeleteRow(currentName)
                    }

                    // Refresh the model
                    DB.dbReadAll()
                    libraryListModel.libraryListModelUpdate()
                    optionToolBar.hideOptionToolBar()

                }
            }
        }
        height: 0
        property PropertyAnimation animationOpenMenu2: PropertyAnimation {
            id: animationOpenOptionToolBar
            target: optionToolBar
            property: "height"
            running: false
            to: optionToolBarHeight
            duration: 100
            easing.type: Easing.Linear
        }
        property PropertyAnimation animationCloseMenu2: PropertyAnimation {
            id: animationCloseOptionToolBar
            target: optionToolBar
            property: "height"
            running: false
            to: 0
            duration: 150
            easing.type: Easing.Linear
        }
        Component.onCompleted: {
            optionToolBarHeight= columnLayout2.implicitHeight;
        }
        function showOptionToolBar() {
            animationOpenOptionToolBar.start()
            optionToolBar.forceActiveFocus()
            isOpened=true
        }
        function hideOptionToolBar() {
            animationCloseOptionToolBar.start()
            setItemSelectForAll(false);
            isOpened=false
        }
        function setItemSelectForAll(value) {
            for (var i = 0; i < listView.count; i++) {
                var delegateItem = listView.itemAtIndex(i);
                if (delegateItem) {
                    console.log("delegateItem.itemSelect " + libraryListModel.get(i).itemSelect)
                    console.log("delegateItem.selectStatus.visible " + delegateItem.selectStatus.visible)
                    delegateItem.selectStatus.visible = value;
                    libraryListModel.get(i).itemSelect = value;
                }
            }
        }
    }


    ListView {

        id: listView
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        anchors.top: optionToolBar.bottom
        anchors.topMargin: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        spacing: 5
        clip:true
        model: ListModel {
            id:libraryListModel
            function libraryListModelUpdate() {
                optionToolBar.hideOptionToolBar()
                loadingLibrary.running=true
                listView.enabled=false
                libraryListModel.clear()
                for (var i = 0; i < loadedLibrary.length; i++) {
                    append({
                               name: loadedLibrary[i].name,
                               path: loadedLibrary[i].path,
                               videosN: loadedLibrary[i].videosN,
                               itemSelect: false
                           })
                }
                listView.enabled=true

                loadingLibrary.running=false

            }
        }

        Layout.fillWidth: true
        delegate: Pane {
            id:delegateLibrary
            contentHeight:drow.implicitHeight
            Material.elevation: 2
            Material.background:  listView.currentIndex === index && mouseArea.pressed ? Material.Indigo: "#2a292f"
            height: drow.implicitHeight+20
            bottomPadding: 10
            topPadding: 10
            property bool forSelect: false
            property int index: index
            property bool isPathExists: false
            property var selectStatus: selectStatus
            MouseArea {
                id: mouseArea
                anchors.fill: parent
                hoverEnabled: true
                signal itemSelected()
                signal itemDeselected()

                // Handle pressed event
                onPressed: {

                    // Set the ListView's currentIndex to the index of this item
                    listView.currentIndex = index
                    console.log("onPressed on:", name.replace(/^"(.*)"$/, "$1"))
                    if(itemSelect)
                        forSelect=false
                    else
                        forSelect=true
                }

                // Handle released event
                onReleased: {
                    console.log("onReleased")

                    // If the ListView's currentIndex matches the index of this item, consider it a click
                    if (listView.currentIndex === index&& !itemSelect && !optionToolBar.height>0 && isPathExists) {
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
                        return;
                    }
                    else if(forSelect && optionToolBar.height>0)
                    {
                        itemSelected()
                        return;
                    }
                    else if(itemSelect && !forSelect) {
                        itemDeselected()
                        return;
                    }
                    else if(!isPathExists){

                        warringStorageMsg.open()
                    }


                }
                onPressAndHold: {
                    itemSelected()
                    console.log("Long-pressed on:", name.replace(/^"(.*)"$/, "$1"))
                }
                onItemSelected: {
                    selectStatus.visible=true
                    itemSelect=true

                    optionToolBar.showOptionToolBar()

                }
                onItemDeselected: {
                    var isSomeItemSelected = false
                    selectStatus.visible=false
                    itemSelect=false
                    for (var i = 0; i < libraryListModel.count; i++) {
                        var item = libraryListModel.get(i)
                        if (item.itemSelect) {
                            isSomeItemSelected = true
                        }
                    }

                    if(!isSomeItemSelected)
                        optionToolBar.hideOptionToolBar()

                }


            }
            Component.onCompleted: {
                width = parent.width
            }
            Connections{
                target:libraryViewParent
                function onWidthChanged() {
                    width = parent.width
                }

            }
            MessageDialog {
                id:warringStorageMsg
                buttons: MessageDialog.Ok
                title: "Pack not found !"
                text: "This pack not exists please make sure is in path."
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
                        id:textDisplay
                        text: name.replace(/^"(.*)"$/, "$1")
                        font.pixelSize: 16
                        elide: Text.ElideRight
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
                Item {
                    id:storageStatus
                    Layout.alignment: Qt.AlignRight
                    width: 24
                    height: 24
                    Layout.rightMargin: 20

                    Image {
                        id: packSourceIcon
                        source: "qrc:/qml/icons/cil-usb.svg"
                        sourceSize.width: 24
                        sourceSize.height: 24
                        fillMode: Image.PreserveAspectFit
                    }
                    ColorOverlay {
                        anchors.fill: packSourceIcon
                        source: packSourceIcon
                        property  color  colorValue:"gray"
                        Component.onCompleted: {
                            if (Qt.platform.os === "linux") {
                                if (linuxUtils.isFileExists(path)) {
                                    colorValue = "green"
                                    delegateLibrary.isPathExists=true
                                } else {
                                    colorValue = "red"
                                    delegateLibrary.isPathExists=false
                                }
                            }
                            else if(Qt.platform.os === "android") {
                                if (androidUtils.isFileExists(path)) {
                                    colorValue = "green"
                                    delegateLibrary.isPathExists=true
                                } else {
                                    colorValue = "red"
                                    delegateLibrary.isPathExists=false
                                }
                            }

                        }

                        color:colorValue
                        antialiasing: true
                    }
                }
                Item {
                    id:selectStatus
                    Layout.alignment: Qt.AlignRight | Qt.AlignTop
                    width: 20
                    height: 20
                    Layout.rightMargin: 1
                    visible: false
                    Image {
                        id: selectIcon
                        source: "qrc:/qml/icons/cil-check-circle.svg"
                        sourceSize.width: 20
                        sourceSize.height: 20

                        fillMode: Image.PreserveAspectFit
                    }
                    ColorOverlay {
                        anchors.fill: selectIcon
                        source: selectIcon
                        color: "#2196F3"
                        antialiasing: true
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


            var projectFile= libraryfileDialog.currentFile
            JsonFile.name = projectFile
            var name =jsonOperator.getInfopack(JsonFile)
            var videon=jsonOperator.getvideoNumbers(JsonFile)

            selectedFilePath =projectFile
            DB.dbInit()
            DB.dbInsert(name, projectFile,videon)
            DB.dbReadAll()

            libraryListModel.libraryListModelUpdate()

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

