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
    visibility: Window.Windowed
    title: qsTr("hello world")
    menuBar: MenuBar {
        Material.background: win.color
    }
    header: ToolBar {
        Material.background: win.color
        RowLayout {
            spacing: 20
            anchors.fill: parent

            Image {
                id: logo
                source: "qrc:/qml/icons/SonegX_Media_Player_S_LOGO-64px.png"
                horizontalAlignment: Image.AlignLeft
                verticalAlignment: Image.AlignTop
                antialiasing: true
                Layout.leftMargin: 20
            }

            Label {
                id: menuTitle
                font.bold: true
                text: win.mentitle
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.family: "Segoe UI"
            }

            ToolButton {
                id: showAddbtn
                visible: win.showAddbtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-plus.svg"
                onClicked:{
                    console.log(win.visibility)
                    menu.open()}
            }
        }


    }
    footer: ToolBar {
        Material.background: "#2e2f30"
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20
            FooterBtn {
                id:btn1
                text: "   Videos  "
                icon.source: "qrc:/qml/icons/cil-movie.svg"
                onClicked: {
                    swipeView.currentIndex = 0
                }
                function videosView_Activeted(){
                    if(!activated){
                        win.showAddbtn=false
                        win.mentitle="Videos"
                        btn1.activated=true
                        btn2.activated=false
                        btn3.activated=false
                    }
                }
            }
            FooterBtn {
                id:btn2
                icon.source: "qrc:/qml/icons/cil-album.svg"
                text: " Library "
                onClicked: {
                    swipeView.currentIndex = 1
                }
                function libraryView_Activeted(){
                    if(!activated){
                        win.showAddbtn=true
                        win.mentitle="Files"
                        btn1.activated=false
                        btn2.activated=true
                        btn3.activated=false
                    }
                }
            }
            FooterBtn {
                id:btn3
                text: "Settings"
                icon.source: "qrc:/qml/icons/cil-settings.svg"
                onClicked:{
                    swipeView.currentIndex = 2
                }
                function settingsView_Activeted(){
                    if(!activated){
                        btn1.activated=false
                        btn2.activated=false
                        btn3.activated=true
                    }
                }

            }
        }
    }
    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 0
        LibraryView {}
        VideosView {}
        SettingsView {}
        Component.onCompleted: {
            win.mentitle="Videos"
            btn1.activated=true
        }
        onCurrentIndexChanged: {
            // Call a function based on the new index
            switch (swipeView.currentIndex) {
            case 0:
                btn1.videosView_Activeted();
                break;
            case 1:
                btn2.libraryView_Activeted();
                break;
            case 2:
                btn3.settingsView_Activeted();
                break;
            }
        }
    }
}
