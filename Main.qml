import QtQuick
import QtQuick.Window
import QtQuick.Controls.Material 2.2
import QtQuick.Controls 6.3
import QtQuick.Layouts 1.3
ApplicationWindow  {
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
                 text: "Title"
                 elide: Label.ElideRight
                 horizontalAlignment: Qt.AlignHCenter
                 verticalAlignment: Qt.AlignVCenter
                 Layout.fillWidth: true
             }

         }
     }

    footer: ToolBar {
           RowLayout {
               anchors.fill: parent

              /* ToolButton {
                   text: qsTr("‹")
                   onClicked: stack.pop()
               }*/
                   RowLayout {
                         anchors.horizontalCenter: parent.horizontalCenter
                       spacing: 20
                       ToolButton {
                           text: "Button 1"
                           onClicked: {
                              stackView.pop()
                               console.log("Button 1 clicked")
                           }
                       }
                       ToolButton {
                           text: "Button 2"
                           onClicked: {
                                 stackView.push(app.videoView)
                               console.log("Button 2 clicked")
                           }
                       }
                       ToolButton {
                           text: "Button 3"
                           enabled: stackView.depth > 1
                                       onClicked: stackView.pop()
                       }

                   }


               ToolButton {
                   text: qsTr("⋮")
                   onClicked: menu.open()
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
