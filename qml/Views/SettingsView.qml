import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3

Item {
    ColumnLayout {
        anchors.fill: parent
        spacing: 10

        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 10

            Label {
                id: serialLabel
                text: qsTr("SN :")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            Label {
                id: serialValue
                text: qsTr("SN :")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            ToolButton{
                id:copyBtn
                text:"Copy"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
        }

        TextField {
            id: keytext
            font.pixelSize: 18
            horizontalAlignment: Text.AlignHCenter
            maximumLength: 24
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        }
        Component.onCompleted: {
            var charWidth = fontMe.width
            keytext.Layout.preferredWidth = charWidth * 24
            console.log( keytext.Layout.preferredWidth )
        }
        TextMetrics {
            id: fontMe
            font.family: keytext.font.family
            font.pixelSize: keytext.font.pixelSize
            text: "A"
        }







        RowLayout {
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            Layout.fillWidth: true
            spacing: 10
            Label {
                id: statusLabel
                text: qsTr("Status: Activted")
            }
            ToolButton{
                id:activeBtn
                text:"Active"
            }
        }
        Label {
            id: about
            text: qsTr("SONEGX Player")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        Label {
            id: aboutVersion
            text: qsTr("Vesion 1.0")
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
        }
        Image {
            id: logo
            source: "qrc:/qml/icons/SonegX_Media_Player_LOGO-128px.png"
            Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            antialiasing: true
        }




    }

}
