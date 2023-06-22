import QtQuick
import QtQuick.Window
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import "Views"
import "controls"

ApplicationWindow  {
    property string mentitle: "title"
    property bool showAddbtn: true
    property bool showRefreshBtn: false
    property var videoList: []
    property var currentPathPack
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    id:win
    visible: true
    visibility: Window.Windowed
    title: qsTr("hello world")
function switchToVideosView(){
    console.log("switchToVideosView()")
 swipeView.currentIndex = 1
}
function playVideo(videoPath){
videoPlayerWindow.player.source=videoPath

       console.log("    win.currentPathPack"+win.currentPathPack)
    console.log("videopppppppppp"+videoPlayerWindow.player.source)
    internal.playMode()
videoPlayerWindow.visible=true

videoPlayerWindow.player.play()
}
function testplayVideo(videoPath){
videoPlayerWindow.player.source=videoPath
    console.log("videoPlayerWindow.player.source "+videoPlayerWindow.player.source)
    internal.playMode()
videoPlayerWindow.visible=true

videoPlayerWindow.player.play()
}
    QtObject {
        id: internal
        function playMode(){
            win.header.visible=false
            win.footer.visible=false
            // win.menuBar.visible=false
            swipeView.visible=false
            win.visibility= Window.FullScreen
        }
        function basicMode(){
            win.header.visible=true
            win.footer.visible=true
            // win.menuBar.visible=true
            swipeView.visible=true
            win.visibility= Window.Windowed
        }
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
                //   elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.family: "Segoe UI"
            }
            ToolButton {
                id: addbtn
                visible: win.showAddbtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-plus.svg"
                onClicked:{
                    libraryV.libraryfileDialog.visible = true
                }
            }
            ToolButton {
                id: refreshBtn
                visible: win.showRefreshBtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-reload.svg"
                onClicked:{
                }
            }
        }
    }
    footer: ToolBar {
        Material.background: "#2e2f30"
        RowLayout {
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 20

            FooterBtn {
                id:libraryBtn
                icon.source: "qrc:/qml/icons/cil-album.svg"
                text: " Library "
                onClicked: {
                    swipeView.currentIndex = 0
                }
                function libraryView_Activeted(){
                    if(!activated){
                        win.mentitle="Library"
                        win.showAddbtn=true
                        win.showRefreshBtn=false
                        libraryBtn.activated=true
                        videosBtn.activated=false
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:videosBtn
                text: "   Videos  "
                icon.source: "qrc:/qml/icons/cil-movie.svg"
                onClicked:{
                    swipeView.currentIndex = 1
                }
                function videosView_Activeted(){
                    if(!activated){
                            console.log("videosView_Activeted()")
                        videosV.videoListModel.updateModel()
                        win.mentitle="Videos"
                        win.showAddbtn=false
                        win.showRefreshBtn=true
                        libraryBtn.activated=false
                        videosBtn.activated=true
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:settingsBtn
                text: "Settings"
                icon.source: "qrc:/qml/icons/cil-settings.svg"
                onClicked:{
                    swipeView.currentIndex = 2
                }
                function settingsView_Activeted(){
                    if(!activated){
                        win.mentitle="Settings"
                        win.showAddbtn=false
                        win.showRefreshBtn=true
                        libraryBtn.activated=false
                        videosBtn.activated=false
                        settingsBtn.activated=true
                    }
                }

            }
        }
    }
    VideoPlayer {
        id: videoPlayerWindow
        //      visible: false
        anchors.fill: parent
        // Other properties and settings for the video player window
    }
    SwipeView {
        id: swipeView
 interactive:false
        anchors.fill: parent
        currentIndex: 0
        LibraryView {
            id:libraryV
        }
        VideosView {
            id:videosV
        }

        SettingsView {}
        Component.onCompleted: {
            win.mentitle="Library"
            libraryBtn.activated=true
        }
        onCurrentIndexChanged: {
                console.log("swipeView.currentIndex"+swipeView.currentIndex)
            // Call a function based on the new index
            switch (swipeView.currentIndex) {
            case 0:
                libraryBtn.libraryView_Activeted();
                break;
            case 1:
                videosBtn.videosView_Activeted();
                break;
            case 2:
                settingsBtn.settingsView_Activeted();
                break;
            }
        }
    }
    onClosing: function(close) {
        close.accepted = false
        videoPlayerWindow.player.stop(); // Stop the video playback if needed
        console.log("Child window is closing …")
        if(videoPlayerWindow.visible==false)
        {
            close.accepted = true
            Qt.quit()
        }
        else{
            videoPlayerWindow.visible=false
            internal.basicMode()
        }

    }
    Component.onCompleted: {
            androidUtils.setSecureFlag()
    }

}
