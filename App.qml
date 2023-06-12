import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.0
Item {

    anchors.fill: parent
    property Component mainView: mainViewComponent
    property Component videoView: videoViewComponent
   Component {
   id: mainViewComponent
    GridLayout {

        rows: 1
        columns: 3
        Button {
            id: button
            text: qsTr("Button")
        }

        Button {
            id: button1
            text: qsTr("Button 111")
            onClicked: {
                console.log("Button 2 clicked")
            }
        }

        Button {
            id: button2
            text: qsTr("Button")
        }

        Button {
            id: button3
            text: qsTr("Button")
        }

        Button {
            id: button4
            text: qsTr("Button")
        }

        Button {
            id: button5
            text: qsTr("Button")
        }

        Button {
            id: button6
            text: qsTr("Button")
        }
    }
   }
   Component {
   id: videoViewComponent
    GridLayout {

        rows: 1
        columns: 3

        Button {
            id: button
            text: qsTr("Button")
        }



        Button {
            id: button2
            text: qsTr("Button")
        }

        Button {
            id: button3
            text: qsTr("Button")
        }


    }
   }

}

