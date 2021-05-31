// @dart=2.9

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lengage_app/util/firebase_api/database.dart';
import 'package:lengage_app/views/widgets/chat_bubble.dart';
import 'package:lengage_app/util/data.dart';
import 'package:translator/translator.dart';
import 'package:intl/intl.dart';

String translation;
String myLang;
final translator = GoogleTranslator();
String myName;
String name;
String chatRoomId;
Stream chats;
var maxMessageToDisplay;
var _scrollController;

class Conversation extends StatefulWidget {
  @override
  _ConversationState createState() => _ConversationState();
  Conversation(String nameOther, String chatroomId, String lang) {
    name = nameOther;
    myLang = lang;
    if (DatabaseMethods().getChats(chatRoomId) != null) {
      chatRoomId = chatroomId;
    } else {
      chatRoomId = getChatRoomId(name, myName);
    }

    myName = FirebaseAuth.instance.currentUser.displayName.toString();
  }

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }
}

class _ConversationState extends State<Conversation> {
  TextEditingController messageEditingController = new TextEditingController();

  addMessage() async {
    if (messageEditingController.text.isNotEmpty) {
      Map<String, dynamic> chatMessageMap = {
        "sendBy": myName,
        "message": messageEditingController.text,
        'time': DateTime.now().millisecondsSinceEpoch,
      };
      //get translation;
      translator
          .translate(chatMessageMap["message"], to: myLang)
          .then((result) {
        chatMessageMap["translation"] = result.toString();
        DatabaseMethods().addMessage(chatRoomId, chatMessageMap);
      });

      setState(() {
        messageEditingController.text = "";
      });
    }
  }

  @override
  void initState() {
    maxMessageToDisplay = 20;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        setState(() {
          maxMessageToDisplay += 20;
        });
      }
    });
    DatabaseMethods().getChats(chatRoomId).then((val) {
      setState(() {
        chats = val;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 3,
        leading: IconButton(
          icon: Icon(
            Icons.keyboard_backspace,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        titleSpacing: 0,
        title: InkWell(
          child: Row(
            children: <Widget>[
              Padding(
                padding: EdgeInsets.only(left: 0.0, right: 10.0),
                child: CircleAvatar(
                  backgroundImage: AssetImage(
                    "assets/images/cm${random.nextInt(10)}.jpeg",
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      "Online",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.more_horiz,
            ),
            onPressed: () {},
          ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: <Widget>[
            Flexible(
                child: StreamBuilder(
              stream: chats,
              builder: (context, snapshot) {
                return snapshot.hasData
                    ? ListView.builder(
                        itemCount: snapshot.data.docs.length,
                        reverse: true,
                        itemBuilder: (context, index) {
                          var length = snapshot.data.docs.length;
                          Map msg =
                              snapshot.data.docs[length - 1 - index].data();

                          return ChatBubble(
                            message: msg["message"],
                            trans: msg["translation"],
                            username: msg["sendBy"],
                            time: readTimestamp(msg["time"]),
                            type: "text",
                            replyText: " yeahh",
                            isMe: myName == msg["sendBy"],
                            isGroup: false,
                            isReply: false,
                            replyName: "",
                          );
                        })
                    : Container();
              },
            )),
            Align(
              alignment: Alignment.bottomCenter,
              child: BottomAppBar(
                elevation: 10,
                color: Theme.of(context).primaryColor,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: 100,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      IconButton(
                        icon: Icon(
                          Icons.add,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {},
                      ),
                      Flexible(
                        child: TextField(
                          controller: messageEditingController,
                          style: TextStyle(
                            fontSize: 15.0,
                            color: Theme.of(context).textTheme.headline6.color,
                          ),
                          decoration: InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            hintText: "Write your message...",
                            hintStyle: TextStyle(
                              fontSize: 15.0,
                              color:
                                  Theme.of(context).textTheme.headline6.color,
                            ),
                          ),
                          maxLines: null,
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.send,
                          color: Theme.of(context).accentColor,
                        ),
                        onPressed: () {
                          addMessage();
                        },
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String readTimestamp(int timestamp) {
    var now = DateTime.now();

    var format = DateFormat('HH:mm a');
    var date = DateTime.fromMillisecondsSinceEpoch(timestamp);
    var diff = now.difference(date);
    var time = '';

    if (diff.inSeconds <= 0 ||
        diff.inSeconds > 0 && diff.inMinutes == 0 ||
        diff.inMinutes > 0 && diff.inHours == 0 ||
        diff.inHours > 0 && diff.inDays == 0) {
      time = format.format(date);
    } else if (diff.inDays > 0 && diff.inDays < 7) {
      if (diff.inDays == 1) {
        time = diff.inDays.toString() + ' DAY AGO';
      } else {
        time = diff.inDays.toString() + ' DAYS AGO';
      }
    } else {
      if (diff.inDays == 7) {
        time = (diff.inDays / 7).floor().toString() + ' WEEK AGO';
      } else {
        time = (diff.inDays / 7).floor().toString() + ' WEEKS AGO';
      }
    }

    return time;
  }
}
