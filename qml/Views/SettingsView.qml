import QtQuick
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import "qrc:/qml/Database.js" as DB
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
                    // text: qsTr("Activted")
                    function checkStatus(){
                          var deviceID
                        if (Qt.platform.os !== "android") {
                                                deviceID= linuxUtils.linuxMachineUniqueId()
                                            } else {
                                                deviceID= androidUtils.getAndroidID()
                                            }
                        var serianN=keytext.text
                        if(ActivateSys.checkDecryption(serianN,deviceID))
                        {
                            statusValue.text="Activated"
                            statusValue.color="green"
                        }
                        else{
                            statusValue.text="Unactivated"
                            statusValue.color="red"
                        }

                    }
                    Component.onCompleted: {
                        checkStatus()
                    }
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
                    //text:"chaimakram abdeslem"
                    Component.onCompleted: {
                        if (Qt.platform.os !== "android") {
                            text= linuxUtils.linuxMachineUniqueId()
                        } else {
                            text= androidUtils.getAndroidID()
                        }

                    }
                }

                ToolButton{
                    id:copyBtn
                    icon.source: "qrc:/qml/icons/cil-copy.svg"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onClicked: {
                        clipboardExtension.setText(serialValue.text)
                        copiedTollTip.show("Copied !")}
                }
            }
            TextField {
                id: keytext
                font.pixelSize: 18
                horizontalAlignment: Text.AlignHCenter
                maximumLength: 24
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                selectByMouse: true
                Component.onCompleted: {
                    text= ActivateSys.getEncryptedId()
                }
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

            Button{
                id:activeBtn
                text:"Active"
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                onClicked: {
                      var deviceID
                    if (Qt.platform.os !== "android") {
                        deviceID= linuxUtils.linuxMachineUniqueId()
                    } else {
                        deviceID= androidUtils.getAndroidID()
                    }
                    var serianN=keytext.text
                    if(ActivateSys.activate(serianN,deviceID)){
                        copiedTollTip.show("Activated !")
                        statusValue.checkStatus()
                    }
                    else
                        copiedTollTip.show("Serial not correct!")
                }

            }

            Button{
                Material.foreground: Material.Red
                id:clearDbBtn
                text:"Clean Library"
                onClicked:  {
                    DB.dbRemove()
                    win.libraryV.libraryListModel.clear()
                }
                Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
            }
            ToolTip {
                id:copiedTollTip
                timeout: 2000
            }


        }
    }

}


