import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3

Item {
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
                videoPlayerWindow.visible=true
                swipeView.visible=false
            }
        }
        Button {
            id: button2
            text: qsTr("Button2222")
            onClicked: {
             //   androidUtils.rotateToPortrait()
            }
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

