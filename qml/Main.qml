import QtQuick
import QtQuick.Window
import QtQuick.Controls.Material 2.3
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import QtQuick.Dialogs
import Qt.labs.platform
import "Views"
import "controls"
ApplicationWindow  {
    property string mentitle: "title"
    property bool showAddbtn: true
    property bool showRefreshBtn: false
    property bool showInfohBtn: false
    property var videoList: []
    property var currentPathPack
    property var currentVideoname
    property string currentHVideoname
    property string currentVideoDesc: ""
    property VideoPlayer videoPlayerWindow
    property LibraryView libraryV:libraryV
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    id:win
    visible: true
    visibility: Window.Windowed
    title: qsTr("SoneGX player")
    MessageDialog {
        id:activiationMsg
        buttons: MessageDialog.Ok
        title: "Info"
        informativeText: "You need to activate SoneGX player in settings."
        onOkClicked: {
            swipeView.currentIndex = 2
        }
    }
    Popup {
        id:popUpAbout
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2
        rightMargin:20
        leftMargin: 20
        topMargin: 20
        bottomMargin: 20
        modal: true

        contentWidth: view.implicitWidth
        contentHeight: view.implicitHeight
        ScrollView{
            id: view
            anchors.fill: parent
            contentWidth: columnLayout.implicitWidth
            contentHeight: columnLayout.implicitHeight
            ColumnLayout {
                id:columnLayout
                anchors.fill: parent
                spacing: 40
                Label {
                    id: aboutVersion233
                    text: qsTr("About")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.bottomMargin: 5
                    font.bold: true
                }
                Image {
                    id: logo23
                    source: "qrc:/qml/icons/SonegX_Media_Player_LOGO-256px.png"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    antialiasing: true
                }
                Label {
                    id: aboutVersion23
                    text: qsTr("Vesion 1.6")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    Layout.bottomMargin: 15
                }
                Label {
                    id: website
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text: "Website: <a href='https://www.onlinemusikschule.info'>www.onlinemusikschule.info</a>"
                    onLinkActivated:Qt.openUrlExternally("https://www.onlinemusikschule.info")
                }
                Label {
                    id: serialValue2
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"Top Shop Group Ltd."

                }
                Label {
                    id: serialValue3
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"Covent Garden"

                }
                Label {
                    id: serialValue4
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    text:"London, WC2H 9JQ"

                }
                Label {
                    id: email
                    text: qsTr("Email: support@onlinemusikschule.info")
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                }
                Label {
                    id: email4
                    text: "Phone: <a href='+43 680 2090144'>+43 680 2090144</a>"
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    onLinkActivated: {

                        var url = "tel:+43 680 2090144";
                        Qt.openUrlExternally(url)

                    }
                }

            }

        }

    }
    function checkActivation(){
        var deviceID;
        var serianN;

        if (Qt.platform.os === "android") {
            deviceID = androidUtils.getAndroidID();
        } else if (Qt.platform.os === "windows") {
            deviceID = winUtils.winMachineUniqueId();
        } else if (Qt.platform.os === "linux") {
            deviceID = linuxUtils.linuxMachineUniqueId();
        } else {
            // Handle unsupported OS
            return false;
        }

        serianN = ActivateSys.getEncryptedId();

        if(ActivateSys.checkDecryption(serianN, deviceID))
            return true;
        else
            return false;
    }

    function switchToVideosView(){
        console.log("switchToVideosView()")
        swipeView.currentIndex = 1
    }

    function playNowVideo(fullname) {
        popupInfo.close()
        internal.createVideoPlayerWindow()
        win.videoPlayerWindow.player.source=fullname
        internal.playMode()
        win.videoPlayerWindow.visible=true
        win.videoPlayerWindow.player.play()
    }
    function playVideo(videoPath){
        if(checkActivation()){
            console.log(videoPath)
            playNowVideo(videoPath)
        }
        else
            activiationMsg.open()
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
            if (Qt.platform.os === "android")
                win.visibility= Window.FullScreen
        }
        function basicMode(){
            win.header.visible=true
            win.footer.visible=true
            // win.menuBar.visible=true
            swipeView.visible=true
            win.visibility= Window.Windowed
        }
        function createVideoPlayerWindow() {
            var component = Qt.createComponent("qrc:/qml/Views/VideoPlayer.qml");
            if (component.status ===  Component.Ready) {
                var videoPlayerWindow = component.createObject(win);
                if (videoPlayerWindow === null) {
                    console.error("Error creating VideoPlayerWindow");
                } else {
                    // Initialize properties and settings for the new VideoPlayer
                    // ...
                    win.videoPlayerWindow=videoPlayerWindow
                }
            } else {
                console.error("Error loading VideoPlayer.qml:", component.errorString());
            }
        }
    }

    Popup {
        id: popupInfo
        x: (parent.width - width) / 2
        y: (parent.height - height) / 2

        contentItem: RowLayout{
            Text {
                id:popupInfoText
                text: "Content"
                color:"white"
            }
            BusyIndicator{
                id:popupInfoBusyIndicator
                visible: false
            }
        }
        modal: true
        focus: true
        closePolicy: Popup.NoAutoClose
    }
    header: ToolBar {
        Material.background: win.color
        RowLayout {
            spacing: 10
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
                //font.bold: true
                text: win.mentitle
                Layout.leftMargin: parent.width/2 - logo.width - implicitWidth
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
                font.family: "Segoe UI"
            }


            ToolButton {
                id: refreshLibrary
                Layout.leftMargin: 0
                icon.source: "qrc:/qml/icons/cil-reload.svg"
                visible:swipeView.currentIndex == 0 ? true: false
                onClicked:{
                    libraryV.libraryListModel.libraryListModelUpdate()
                }

            }
            ToolButton {
                id: addbtn
                visible: win.showAddbtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-plus.svg"
                onClicked:{
                    if(Qt.platform.os === "android"){
                        if (androidUtils.checkStoragePermission())
                            libraryV.libraryfileDialog.visible = true
                        else
                            return
                    }
                    else
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
            ToolButton {
                id: infoBtn
                visible: win.showInfohBtn
                Layout.leftMargin: 0
                Layout.rightMargin: 20  // Add right padding of 20 units
                icon.source: "qrc:/qml/icons/cil-info.svg"
                onClicked:{
                    popUpAbout.open()
                }
            }
        }
    }
    footer: ToolBar {
        Material.background: "#2e2f30"
        RowLayout {
            anchors.fill: parent
            Layout.fillWidth: true
            Layout.alignment :Qt.AlignHCenter | Qt.AlignVCenter
            spacing: 20
            FooterBtn {
                id:libraryBtn
                icon.source: "qrc:/qml/icons/cil-album.svg"
                text: " Library "
                Layout.alignment :Qt.AlignRight | Qt.AlignVCenter

                onClicked: {
                    swipeView.currentIndex = 0
                }
                function libraryView_Activeted(){
                    if(!activated){
                        win.mentitle="Library"
                        win.showAddbtn=true
                        win.showRefreshBtn=false
                        win.showInfohBtn=false
                        libraryBtn.activated=true
                        videosBtn.activated=false
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:videosBtn
                text: "   Videos  "
                Layout.alignment :Qt.AlignHCenter | Qt.AlignVCenter
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
                        win.showInfohBtn=false
                        libraryBtn.activated=false
                        videosBtn.activated=true
                        settingsBtn.activated=false
                    }
                }
            }
            FooterBtn {
                id:settingsBtn
                text: "Settings"
                Layout.alignment :Qt.AlignLeft | Qt.AlignVCenter
                icon.source: "qrc:/qml/icons/cil-settings.svg"

                onClicked:{
                    swipeView.currentIndex = 2
                }
                function settingsView_Activeted(){
                    if(!activated){
                        win.mentitle="Settings"
                        win.showAddbtn=false
                        win.showRefreshBtn=false
                        win.showInfohBtn=true
                        libraryBtn.activated=false
                        videosBtn.activated=false
                        settingsBtn.activated=true
                    }
                }

            }
        }
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
        if(Qt.platform.os === "android"){
            close.accepted = false
            if(popupInfo.visible==true|| popUpAbout.visible==true){
                popupInfo.close()
                popUpAbout.close()
            }
            else if(libraryV.optionToolBar.isOpened){
                libraryV.optionToolBar.hideOptionToolBar()
            }
            else if(win.videoPlayerWindow!=null)
            {
                if(win.videoPlayerWindow.currentOrientation==0)
                    androidUtils.rotateToPortrait()
                //win.videoPlayerWindow.player.stop(); // Stop the video playback if needed
                win.videoPlayerWindow.visible=false
                win.videoPlayerWindow.destroy()
                win.videoPlayerWindow = null
                console.log("Child window is closing …")
                internal.basicMode()

            }
            else if (swipeView.currentIndex!=0){

                swipeView.currentIndex = 0
            }
            else{
                close.accepted = true
                Qt.quit()
            }
        }
        else{

            close.accepted = true
            Qt.quit()
        }

    }
    Component.onCompleted: {
        // Set window size for non-Android platforms
        if (Qt.platform.os !== "android") {
            width = 800; // Set the desired width
            height = 600; // Set the desired height
        } else {
            // Handle Android-specific setup
            androidUtils.setSecureFlag();
        }

        // Create video player window
        internal.createVideoPlayerWindow();

        // Check activation status and show message if not activated
        if (!checkActivation()) {
            activiationMsg.open();
        }

    }

}
