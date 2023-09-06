import QtQuick
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
import Qt5Compat.GraphicalEffects

Item {
    property ListModel videoListModel: videoListModel
    property color overlayColor2: Material.color(Material.Blue)
    ListView {
        id: videoListView
        anchors.fill: parent
        spacing: 5
        anchors.rightMargin: 5
        anchors.leftMargin: 5
        anchors.bottomMargin: 5
        anchors.topMargin: 5
        // Create a ListModel to store the video information
        model: ListModel {
            id: videoListModel
            function updateModel(){
                console.log("updateModel()")
                videoListModel.clear()
                var videosInfo = win.videoList
                // Add each video info to the ListModel
                for (var i = 0; i < videosInfo.length; i++) {
                    videoListModel.append({
                                              vbaseName: videosInfo[i].vbaseName,
                                              vName: videosInfo[i].vName,
                                              desc: videosInfo[i].desc
                                          })
                }
            }
        }

        // Populate the ListModel with video data

        delegate: Pane {

            id:delegateLibrary
            //  width: parent.width
            width: videoListView.width
            contentHeight:drow.implicitHeight
            Material.elevation: 2
            Material.background:  videoListView.currentIndex === index && mouseArea2.pressed ? Material.Indigo: "#2a292f"
            height: drow.implicitHeight+20
            bottomPadding: 10
            topPadding: 10

            property int index: index
            MouseArea {
                id: mouseArea2
                anchors.fill: parent
                hoverEnabled: true

                // Handle pressed event
                onPressed: {
                    // Set the ListView's currentIndex to the index of this item
                    videoListView.currentIndex = index
                }

                // Handle released event
                onReleased: {
                    // If the ListView's currentIndex matches the index of this item, consider it a click
                    if (videoListView.currentIndex === index) {
                        console.log("Clicked on:")
                        win.currentVideoname=vbaseName
                        win.currentVideoDesc=desc
                        win.playVideo(win.currentPathPack+vbaseName)

                    }
                }
                onPressAndHold: {
                    // Set the ListView's currentIndex to the index of this item
                    videoListView.currentIndex = index
                    // Perform the selection action for long-press
                    console.log("Long-pressed on:")

                }

            }
            RowLayout {
                id:drow
                spacing: 20
                anchors.fill: parent
                Layout.minimumWidth: parent.width
                Layout.fillWidth: true
                Item {
                    Layout.alignment: Qt.AlignLeft
                    width: 48
                    height: 48
                    Layout.leftMargin: 20
                    Image {
                        id: iconBtn2
                        source: "qrc:/qml/icons/video-icon.png"
                        sourceSize.width: 48
                        sourceSize.height: 48
                        fillMode: Image.PreserveAspectFit
                    }
                    ColorOverlay {
                        anchors.fill: iconBtn2
                        source: iconBtn2
                        color: overlayColor2
                        antialiasing: true
                    }
                }
                ColumnLayout {
                    spacing: 5

                    Label {
                        text: vName
                        font.pixelSize: 16
                        wrapMode: Text.WordWrap
                        Layout.alignment: Qt.AlignLeft
                        Layout.fillWidth: true

                    }

//                    Label {
//                        text: "Videos: " +desc
//                        font.pixelSize: 16
//                        wrapMode: Text.WordWrap
//                        Layout.alignment: Qt.AlignLeft

//                    }
                }
            }
        }
    }
}

