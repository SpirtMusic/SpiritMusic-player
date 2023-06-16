import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3

Item {

    ScrollView{
        id: scrollView
        anchors.fill: parent
        contentWidth: availableWidth
        contentHeight: columnLayout.implicitHeight
        ColumnLayout {
            id:columnLayout
            anchors.fill: parent

            spacing: 40
            Label {
                id: accountLabel
                text: qsTr("Account")
                font.bold: true
                font.pointSize: 18
                font.underline: true
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            RowLayout {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                Layout.fillWidth: true
                spacing: 30
                Label {
                    id: statusLabel
                    text: qsTr("Status:")
                }
                Label {
                    id: statusValue
                    text: qsTr("Activted")
                }
            }
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
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Component.onCompleted: {
                        text= deviceInfo.getAndroidID()
                    }
                }
                ToolButton{
                    id:copyBtn
                    icon.source: "qrc:/qml/icons/cil-copy.svg"
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

            ToolButton{
                id:activeBtn
                text:"Active"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            Image {
                id: logo
                source: "qrc:/qml/icons/SonegX_Media_Player_LOGO-256px.png"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                antialiasing: true
            }
            Label {
                id: aboutVersion
                text: qsTr("Vesion 1.0")
                Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom
                Layout.bottomMargin: 5
            }

        }
    }
}
