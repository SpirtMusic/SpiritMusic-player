import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
 import Qt.labs.platform
import Qt.labs.folderlistmodel 2.15
Item {
     property FolderDialog libraryfileDialog: libraryfileDialog



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



    FolderDialog {
        id: libraryfileDialog
        onAccepted: {
            // Update the folder model when the selection is accepted
          //  folderModel.folder = fileDialog.folder
            folderModel.folder = libraryfileDialog.folder
            //console.log("fileDialog"+folderName)
        }

    }
    FolderListModel {
        id: folderModel
      //  folder: selectedFolder // The selected folder obtained from the FileDialog
       // nameFilters: ["*.txt"] // Filter to only show text files, modify as needed
        showDirs: false // Set to true if you also want to include subdirectories
    }

}

