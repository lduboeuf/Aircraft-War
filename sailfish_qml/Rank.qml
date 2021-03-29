// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 2.0
import QtQuick.Controls 2.4
//import com.star.widget 1.0
import "RemoteStorage.js" as RemoteStorage

Item{
    id:rank_main

    property bool updateRanking: false
    property string userName: ""


    visible: opacity>0
    anchors.fill: parent
    opacity:0
    Behavior on opacity {
        NumberAnimation{duration: 300}
    }

    function keyAction(){}

    function getRankFinished(data){
        updateRanking = false
        busyIndicator.running = false

//        if(error)
//            return

       // console.log(data)

       // var jsondata = JSON.parse(data)
       // if(jsondata){
            var count = data.length
            game_user_count.text = "total people："+count
            rank_model.clear()
            for(var i=0; i<data.length; ++i)
            {
                var temp = {
                    nickname:data[i].name,
                    score:data[i].score,
                    gameRuningTime:data[i].date
                }
                rank_model.append(temp)
            }
       // }
    }

    function resetRank( isOntStart )//刷新排行榜
    {
        if(updateRanking)
            return
        busyIndicator.running = true
        updateRanking = true//避免重复刷新
        rank_model.clear()//先清空原来的排行榜
        rank_list.rank_page = 1
        no_network_lbl.visible = false
        userName = mysettings.getValue("user_uid","")
        RemoteStorage.getAll(API_KEY,getRankFinished,
                             function(error) {
                                 console.log(error)
                                 no_network_lbl.visible = true
                                 busyIndicator.running = false
                             })

        //httpRequest.get(getRankFinished, url)

    }
    function addRank(page)//增加排行榜
    {
        if(updateRanking)
            return
        updateRanking = true//避免重复刷新

        if(rank_model.count>0 ){
            utility.console("增加排行榜")
            //var url="http://api.9smart.cn/ranks?clientid=5&page="+String(page)
            //httpRequest.get(getRankFinished, url)
        }
    }

    Image{
        id:quit

        opacity: 1-user_info_detail.opacity
        source: "qrc:/Image/Button_back.png"
        x:main.width/18
        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        y:main.quit_y

        MouseArea{
            anchors.fill: parent
            onClicked: {
                keyAction()
            }
        }
    }

    Image{
        id: rank01

        source: "qrc:/Image/Rank_01.png"
        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        anchors.horizontalCenter: parent.horizontalCenter
    }
    Image{
        id:rank02

        source: "qrc:/Image/Setting_02.png"
        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.bottom: parent.bottom
    }

    Component{
        id: my_component
        Item{
            width: rank_list.width
            height: main.width/10
            property bool isCurrentUser: rank_main.userName === nickname
            Text {
                id: number

                text: String(index+1)
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 18
                color: isCurrentUser ? "#895253" : "#303030"
            }
            Item{ // MyImage {
                id:user_avatar

                width: parent.height-10
                height: width
                smooth: true
                anchors.left: number.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                //maskSource: "qrc:/Image/mask.bmp"
                //source: avatar
            }
            Text{
                id:user_name

                anchors.left: user_avatar.right
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: user_score.left
                anchors.rightMargin: 10
                elide: Text.ElideRight
                text: nickname
                font.pointSize: 20
                font.family: localFont.name
                color: isCurrentUser ? "#895253" : "#303030"
            }

            Text{
                id: user_score
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
                anchors.rightMargin: 10
                text:score
                font.pointSize: 20
                font.family: localFont.name
                color: isCurrentUser ? "#895253" : "#303030"
            }
            MouseArea{
                anchors.fill: parent
                onClicked: {
                    music.start_music("button")
                    user_info_detail.open( user_model,gameRuningTime )
                }
            }
        }
    }

    ListModel{
        id:rank_model
    }

    Text {
        id: game_user_count
        anchors.bottom: rank01.bottom
        anchors.bottomMargin: 10
        anchors.right: rank_list.right
        color: "black"
        font.pointSize: 18
        font.family: localFont.name
    }

    BusyIndicator {
        id: busyIndicator
        anchors.centerIn: parent
        running: false
    }

    Text {
        id: no_network_lbl
        visible: false
        anchors.centerIn: parent
        color: "black"
        font.pointSize: 18
        font.family: localFont.name
        //elide: Text.ElideRight
        wrapMode: Text.WordWrap
        width: parent.width - 20
        text: qsTr('something went wrong on server or no internet available')
    }

    ListView{
        id:rank_list
        width: rank01.width
        opacity: 1-user_info_detail.opacity
        property int rank_page: 1
        anchors.top: rank01.bottom
        anchors.bottom: rank02.top
        spacing: main.width/25
        anchors.horizontalCenter: parent.horizontalCenter
        clip: true
        delegate: my_component

        model: rank_model


        onMovementEnded: {
            //utility.console("停止滑动")
            if( rank_list.contentY >= rank_list.contentHeight-rank_list.height )
                addRank( ++rank_page )
        }
    }

    Image{
        id:button_updataRank

        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        opacity: 1-user_info_detail.opacity
        source:resetmouse.pressed?"qrc:/Image/button_3_2.png":"qrc:/Image/button_3_1.png"
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: rank02.top
        anchors.topMargin: 20
        MouseArea{
            id:resetmouse
            anchors.fill: parent
            onClicked: {
                music.start_music("button")
                resetRank()//刷新排行榜
            }
        }
        Text{
            anchors.centerIn: parent
            font.family: localFont.name
            font.pointSize: 20
            text: "<b>refresh</b>";
            color: "#303030"
            //visible: main.height!=640?true:false
        }
    }
    Image{
        id: user_info_detail

        width: sourceSize.width*main.width/480
        height: sourceSize.height*main.width/480
        opacity: 0
        Behavior on opacity {
            NumberAnimation{duration: 300}
        }
        source: "qrc:/Image/button_1.png"
        anchors.centerIn: parent
        clip:true
        function open(  text_phone_model, text_game_time ){
            phone_model.text = "Phone model："+text_phone_model
            game_time.text = "Time spent："+String(text_game_time)+"分钟"
            opacity = 1
        }

        Text{
            id: title
            font.family: localFont.name
            text:"details"
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            y: user_info_detail.height/7-height/2
        }
        Text{
            id: phone_model
            font.family: localFont.name
            text:"Phone model："
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: user_info_detail.height/2-height
        }
        Text{
            id: game_time
            font.family: localFont.name
            text:"Time spent："
            font.pointSize: 20
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: user_info_detail.height/2-height
        }
        Image{
            width: sourceSize.width*main.width/480
            height: sourceSize.height*main.width/480
            source:finish_button.pressed? "qrc:/Image/button_2_2.png": "qrc:/Image/button_2_1.png"
            smooth: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: user_info_detail.height/7-height/2
            Text {
                anchors.centerIn: parent
                text: "complete"
                font.family: localFont.name
                font.pointSize: 28
            }
            MouseArea{
                id: finish_button
                anchors.fill: parent
                onClicked: {
                    music.start_music("button")
                    user_info_detail.opacity = 0
                }
            }
        }
    }
}
