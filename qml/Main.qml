import QtQuick
import QtQuick.Window
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import "Views"
import "controls"
ApplicationWindow  {
    property string mentitle: "title"
     property bool showAddbtn: false
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    id:win
    visible: true
    visibility: Window.FullScreen
    title: qsTr("hello world")
    App{
        id:app
    }
    menuBar: MenuBar {
        Material.background: win.color
    }
    header: ToolBar {
        Material.background: win.color
        RowLayout {
            anchors.fill: parent
            Label {
                id:menuTitle
                font.bold: true
                text: win.mentitle
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
            ToolButton {
                visible:win.showAddbtn
                        icon.source: "qrc:/qml/icons/cil-plus.svg"
                         onClicked: menu.open()
                     }

        }
    }

    footer: ToolBar {

            RowLayout {

                anchors.horizontalCenter: parent.horizontalCenter
                spacing: 20
                FooterBtn {
                    id:btn1
                    text: "   Videos  "
                    icon.source: "qrc:/qml/icons/cil-movie.svg"
                    onClicked: {
                        if(!activated){
                            win.showAddbtn=false
                            win.mentitle="Videos"
                            btn1.activated=true
                            btn2.activated=false
                            btn3.activated=false
                            stackView.pop()
                            console.log("Button 1 clicked")
                        }
                    }
                }

                FooterBtn {
                    id:btn2
                    icon.source: "qrc:/qml/icons/cil-album.svg"
                    text: " Library "
                    onClicked: {

                        if(!activated){
                            win.showAddbtn=true
                            win.mentitle="Files"
                            btn1.activated=false
                            btn2.activated=true
                            btn3.activated=false
                            stackView.push(app.videoView)
                            console.log("Button 2 clicked")
                        }
                    }
                }
                FooterBtn {
                    id:btn3
                    text: "Settings"

                    onClicked:{
                           if(!activated){
                        btn1.activated=false
                        btn2.activated=false
                        btn3.activated=true
                           }
                    }
                    icon.source: "qrc:/qml/icons/cil-settings.svg"
                }




        }
    }

    StackView {
        id: stackView
        anchors.fill: parent
        initialItem: app.mainView

        pushEnter: Transition {
            XAnimator {
                from: stackView.width
                to: 0
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        pushExit: Transition {
            XAnimator {
                from: 0
                to: -stackView.width
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        popEnter: Transition {
            XAnimator {
                from: -stackView.width
                to: 0
                duration: 400
                easing.type: Easing.OutCubic
            }
        }

        popExit: Transition {
            XAnimator {
                from: 0
                to: stackView.width
                duration: 400
                easing.type: Easing.OutCubic
            }
        }


    }
}
