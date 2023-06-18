import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform
Item {
    QtObject {
        property string packName
        property int videoNumbers
        id: jsonOperator
        function getInfopack(file){
            var data =  file.read()
            packName=data.Pack_name
            return JSON.stringify(data.Pack_name)
        }
        function getvideoNumbers(file)
        {
            var data =  file.read()
            var videonumbers = [];
            for(var i=0;i<data.videos.length;i++)
            {
                videoNumbers=videoNumbers+i
            }
            return videoNumbers
        }
    }
    property FileDialog libraryfileDialog: libraryfileDialog
    ListView {
        id: listView
        anchors.fill: parent
        model: folderModel
        Layout.fillWidth: true
        delegate: Text {
            text: fileName // Display the file name in the ListView
            //    color: "black"
            font.pixelSize: 16
            wrapMode: Text.WordWrap
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
            jsonOperator.getInfopack(JsonFile)
            jsonOperator.getvideoNumbers(JsonFile)
            return
        }
        onRejected: {
            console.log("Canceled")
            return
        }
    }
}

