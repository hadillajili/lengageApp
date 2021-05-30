// @dart=2.10
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lengage_app/util/firebase_api/database.dart';
import 'package:lengage_app/views/screens/chat/conversation.dart';


DatabaseMethods db = new DatabaseMethods();

class ChatItem extends StatefulWidget {

  final String dp;
  final String name;
  final String time;
  final String trans;
  final String msg;
  final String chatroomId;
  final bool isOnline;
  final int counter;
  final String myLang;

  ChatItem({
    Key key,
    @required this.dp,
    @required this.name,
    @required this.time,
    @required this.msg,
    @required this.trans,
    @required this.myLang,
    @required this.chatroomId,
    @required this.isOnline,
    @required this.counter,
  }) : super(key: key);

  @override
  _ChatItemState createState() => _ChatItemState();
}

class _ChatItemState extends State<ChatItem> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: ListTile(
        contentPadding: EdgeInsets.all(0),
        leading: Stack(
          children: <Widget>[
            CircleAvatar(
              backgroundImage: AssetImage(
                "${widget.dp}",
              ),
              radius: 25,
            ),

            Positioned(
              bottom: 0.0,
              left: 6.0,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(6),
                ),
                height: 11,
                width: 11,
                child: Center(
                  child: Container(
                    decoration: BoxDecoration(
                      color: widget.isOnline
                          ?Colors.greenAccent
                          :Colors.grey,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    height: 7,
                    width: 7,
                  ),
                ),
              ),
            ),

          ],
        ),

        title: Text(
          "${widget.name}",
          maxLines: 1,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: Text(
          "${widget.msg}",
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
        ),
        
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              "${widget.time}",
              style: TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
            ),

            SizedBox(height: 5),
            widget.counter == 0
                ?SizedBox()
                :Container(
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Colors.red,
                borderRadius: BorderRadius.circular(6),
              ),
              constraints: BoxConstraints(
                minWidth: 11,
                minHeight: 11,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 1, left: 5, right: 5),
                child:Text(
                  "${widget.counter}",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
        onTap: (){
          /// create a chatroom if it does't exist, send user to the chatroom, other userdetails
          var myName = FirebaseAuth.instance.currentUser.displayName.toString();
          List<String> users = [myName,widget.name];
          String chatRoomId = getChatRoomId(myName,widget.name);

          Map<String, dynamic> chatRoom = {
            "users": users,
            "chatRoomId" : chatRoomId,
            
          };
          db.addChatRoom(chatRoom, chatRoomId);
          
          Navigator.of(context, rootNavigator: true).push(
            MaterialPageRoute(
              builder: (BuildContext context){
                return Conversation(widget.name,chatRoomId, widget.myLang);
              },
            ),
          );
        },
      ),
    );
  }
  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) { 
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}

