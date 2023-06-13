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
            id: button2
            text: qsTr("Button")
        }

        Button {
            id: button3
            text: qsTr("Button")
        }

    }
}

