// @dart=2.9
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lengage_app/util/firebase_api/database.dart';
import 'package:lengage_app/util/router.dart';
import 'package:lengage_app/views/screens/chat/search.dart';
import 'package:lengage_app/views/widgets/chat_item.dart';
import 'package:translator/translator.dart';
import 'package:intl/intl.dart';
import 'package:lengage_app/util/data.dart';

class Chats extends StatefulWidget {
  @override
  _ChatsState createState() => _ChatsState();
}

class _ChatsState extends State<Chats>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;
  DatabaseMethods db = new DatabaseMethods();
  TextEditingController languageController = new TextEditingController();
  var users;
  var myLang;

  @override
  void initState() {
    super.initState();

    myName = FirebaseAuth.instance.currentUser.displayName.toString();
    setState(() {
      myLang = "en";
    });
    db.getUserChats(myName).then((val) {
      setState(() {
        users = val;
      });
    });
    _tabController = TabController(
        vsync: this,
        initialIndex: 0,
        length: 1); //change length to 2 when adding groups
  }

  TextEditingController searchTextEditingController =
      new TextEditingController();
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: searchTextEditingController,
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
          ),
          onTap: () {
            Navigate.pushPageReplacement(context, Search());
          },
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Theme.of(context).accentColor,
          labelColor: Theme.of(context).accentColor,
          unselectedLabelColor: Theme.of(context).textTheme.caption.color,
          isScrollable: false,
          tabs: <Widget>[
            Tab(
              text: "Message",
            ),
            /*Tab(
              text: "Groups",
            ),*/
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          StreamBuilder(
            //key: UniqueKey(),
            stream: users,
            builder: (context, snapshot) {
              return snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data.docs.length,
                      reverse: false,
                      itemBuilder: (context, index) {
                        Map msg = snapshot.data.docs[index].data();
                        Map chats_data = chats[index];
                        return ChatItem(
                          dp: chats_data['dp'],
                          name: msg["users"][0] != myName
                              ? msg["users"][0]
                              : msg["users"][1],
                          isOnline: true,
                          counter: 0,
                          msg: msg["lastMsg"]["translation"],
                          myLang: this.myLang,
                          time: readTimestamp(msg["lastMsg"]["time"]),
                        );
                      })
                  : Container();
            },
          )
        ],
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.more_horiz,
          color: Colors.white,
        ),
        onPressed: () {
          _displayDialog(context);
        },
      ),
    );
  }

  var _isVisible = false;
  _toggleVisibility() {
    setState(() {
      _isVisible = !_isVisible;
    });
  }

  _unsetVisibility() {
    setState(() {
      _isVisible = false;
    });
  }

  void _displayDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: true,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (BuildContext context, setState) {
            return AlertDialog(
                title: Text('chose messages language'),
                content:
                    Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
                  SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      width: 200.0,
                      height: 60.0,
                      padding: const EdgeInsets.only(
                          top: 10.0, left: 0.0, bottom: 10.0, right: 0.0),
                      child: TextField(
                        controller: languageController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'exp: fr, eng, it,ar..etc',
                        ),
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 18.0,
                        ),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: new FlatButton(
                      child: new Text(
                        'OK',
                        style: TextStyle(color: Colors.teal),
                      ),
                      onPressed: () {
                        db.updateTranslation(languageController.text, myName);
                        Navigator.of(context).pop();
                        this.setState(() {
                          this.myLang = languageController.text;
                        });
                        //this.initState();
                      },
                    ),
                  )
                ]));
          });
        });
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

  @override
  bool get wantKeepAlive => true;
}
