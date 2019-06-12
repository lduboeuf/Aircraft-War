// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.6
import QtQuick.Controls 2.2

Item
{
    id:aboutmain
    opacity:0
    visible: opacity>0
    Behavior on opacity {
        NumberAnimation{duration: 200}
    }
    function keyAction(){}
    Image{
        id:quit
        source: "qrc:/Image/Button_back.png"
        x:main.width/18
        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        y:main.quit_y

        MouseArea{
            anchors.fill: parent
            onClicked: keyAction()
        }
    }

    Image{
        id: about01

        width: sourceSize.width*parent.width/480
        height: sourceSize.height*parent.width/480
        source: "qrc:/Image/About_01.png"
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Image{
        id:about02

        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        source: "qrc:/Image/About_02.png"
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Column {
        id:textContainer
        anchors.centerIn: parent
        //anchors.verticalCenter: parent.verticalCenter
        anchors.margins: 24
//        anchors{
//            top:about01.bottom
//            bottom: about02.top
//            left:about01.left
//            right: about01.right
//        }

        Label {
            id:title
            //width: parent.width
            anchors.horizontalCenter: parent.horizontalCenter
            //anchors.top: about01.bottom
            font.family: localFont.name
            font.bold:true
            text: "Harbour AirCraft"
        }


        Label {
            //width: parent.width
            //anchors.topMargin: 24

            font.family: localFont.name
            textFormat: Text.RichText
            //anchors.top: title.bottom
            //anchors.bottom: about02.top
            onLinkActivated: Qt.openUrlExternally(link)
            text: " This project is a port of AirCraft Game <br/> made by zccrs (github) .<br/> <a href=\"https://github.com/lduboeuf/Aircraft-War\">source code</a> <br/>"
        }
    //    }
    }

//    ListView{
//        id:list
//        clip: true
//        width: parent.width
//        anchors.top: about01.bottom
//        anchors.bottom: about02.top
//        maximumFlickVelocity: 5000
//        model: ListModel{
//            ListElement{
//            }
//        }
//        delegate: Image{
//            width: sourceSize.width*main.width/480
//            height: sourceSize.height*main.width/480
//            source: "qrc:/Image/info_sailfish.png"
//            anchors.horizontalCenter: parent.horizontalCenter
//        }
//    }
}
