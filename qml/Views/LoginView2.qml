import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
Page {
    id: loginPage
    Material.theme: Material.Dark
    Material.accent: Material.Blue
    Rectangle {
        id: iconRect
        width: parent.width
        height: parent.height / 3
        color: "transparent"

        Image {
            id: icontext
            source:"qrc:/qml/icons/SonegX_Media_Player_LOGO-256px.png"
            anchors.centerIn: parent


        }

    }
    ColumnLayout {
        anchors.top: iconRect.bottom
        anchors.right: parent.right
        anchors.left: parent.left
        spacing: 15
        RowLayout{
            id:layout1
            Rectangle {
                id: rectangle1

                height: loginUsername.implicitHeight + 20
                color: "transparent"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                border.width: 1
                Layout.leftMargin: 30
                border.color: "#2196F3"
                Layout.rightMargin: 30
                                radius:   16
                TextField {
                    id: loginUsername
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    overwriteMode: true
                    inputMethodHints: Qt.ImhNoPredictiveText | Qt.ImhPreferLowercase
                    placeholderText: qsTr("Username")
                    //   Layout.preferredWidth: loginPassword.width
                    // Layout.rightMargin: loginPassword.left
                    font.pointSize: 14
                    font.family: "fontawesome"
                    anchors.fill: parent
                    anchors.topMargin: 10
               //     anchors.bottomMargin: 5
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    leftPadding: 30

                    background: Rectangle {
                        id: rectangle
                        implicitWidth: 200
                        implicitHeight: 50
                        radius: implicitHeight / 2
                        color: "transparent"
                        Text {
                            text: "\uf007"
                            font.pointSize: 18
                            font.family: "fontawesome"
                            color: "#2196F3"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                        }

                    }
                    onTextChanged: {
                        console.log("Worrrks")
                    }
                    Component.onCompleted: {
                        focus = true;
                        forceActiveFocus();
                    }

                }
            }
        }
        RowLayout{
            id: rowloayout1
            Rectangle {
                id: rectangle2
    radius:   16
                height: loginUsername.implicitHeight + 20
                color: "transparent"
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                border.width: 1
                Layout.leftMargin: 30
                border.color: "#2196F3"
                Layout.rightMargin: 30
                TextField {
                    id: loginPassword
                    placeholderText: qsTr("Password")
                    //    Layout.preferredWidth: parent.width - 20
                    Layout.alignment: Qt.AlignHCenter
                    Layout.leftMargin: 30
                    font.pointSize: 14
                    font.family: "fontawesome"
                    leftPadding: 30
                    anchors.left: parent.left
                    anchors.right: showPassword.left
                    anchors.top: parent.top
                    anchors.bottom: parent.bottom
                    anchors.topMargin: 10
                    anchors.bottomMargin: 0
                    anchors.leftMargin: 10
                    anchors.rightMargin: 10
                    echoMode: TextField.Password
                    background: Rectangle {

                        implicitWidth: 200
                        implicitHeight: 50
                        radius: implicitHeight / 2
                        color: "transparent"
                        Text {
                            text: "\uf023"
                            font.pointSize: 18
                            font.family: "fontawesome"
                            anchors.left: parent.left
                            anchors.verticalCenter: parent.verticalCenter
                            color: "#2196F3"
                        }


                    }
                }
                ToolButton {
                    id:showPassword
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: parent.right
                    //Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter
                    rightPadding: 20
                    onClicked: {
                        console.log(loginPassword.echoMode)
                        if(loginPassword.echoMode===TextField.Password){
                            loginPassword.echoMode=TextField.Normal
                        }
                        else{
                            loginPassword.echoMode=TextField.Password
                        }
                    }

                    contentItem: Text {
                        text: "   \uf023"
                        font.pointSize: 14
                        color: "#2196F3"
                        font.family: "fontawesome"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter // Center the text horizontally
                    }

                }
            }
        }
        Button{
            Layout.alignment:  Qt.AlignHCenter
            text :"Login"

            Layout.preferredWidth: loginPassword.width /2
            Material.roundedScale:Material.NotRounded
            Material.background: "#2196F3"
            font.pointSize: 14

            font.family: "fontawesome"

        }
        Button{
            Layout.alignment:  Qt.AlignHCenter
            text :"Sign up"

            Layout.preferredWidth: loginPassword.width /2
            Material.roundedScale:Material.NotRounded
            //    Material.background: "#2196F3"
            font.pointSize: 14

            font.family: "fontawesome"

        }
        Text {
            id: name
            text: '<html><style type="text/css"></style><a href="http://google.com">Forgot password?</a></html>' //qsTr("Forgot password?")
            linkColor: Material.accent
            Layout.alignment: Qt.AlignHCenter
            font.pointSize: 14
            color: Material.accent
            Layout.margins: 10
            onLinkActivated: forgotPassword()
        }



    }
    MouseArea {
        anchors.fill: parent
        onClicked: forceActiveFocus()
        z:-1
    }

}
