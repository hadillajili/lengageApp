import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lengage_app/util/firebase_api/database.dart';
import 'package:lengage_app/util/router.dart';
import 'package:lengage_app/views/screens/main_screen.dart';
import 'package:lengage_app/views/widgets/chat_item.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

DatabaseMethods db = new DatabaseMethods();
TextEditingController searchEditingController = new TextEditingController();
var myName = FirebaseAuth.instance.currentUser!.displayName.toString();

class _SearchState extends State<Search> {
  late QuerySnapshot searchResultSnapshot;

  bool isLoading = false;
  bool haveUserSearched = false;
  var users={};

  initiateSearch() async {

    if(searchEditingController.text.isNotEmpty){
 
      setState(() {
        isLoading = true;
      });
       Map map= new Map();
      db.searchByName(searchEditingController.text)
      .then((db_users){
        
        setState(() {
          isLoading = false;
          haveUserSearched = true;
        });
       
        for (var item in db_users) {
          var name = item["name"];
          var email = item["email"];
          map[name]=email;
        }

        setState(() {
          users = map;
        });
        
        }
        
      );
    }
  }


  Widget userList(){
    
    
    return haveUserSearched ? ListView.builder(
      shrinkWrap: true,
      itemCount: users.length,
        itemBuilder: (context, index){ 
          var myName = FirebaseAuth.instance.currentUser!.displayName.toString();
          var otherName=users.keys.elementAt(index).toString();
          String chatRoomId = getChatRoomId(myName,otherName);

          Map<String, dynamic> chatRoom = {
            "users": [myName,otherName],
            "chatRoomId" : chatRoomId,
            "lastMsg":{"message":"start a conversation!", "time":0}
          };
          db.addChatRoom(chatRoom, chatRoomId);
          return ChatItem(
                dp: "",
                name: users.keys.elementAt(index).toString(),
                isOnline: true,
                counter: 0, 
                msg: "", 
                time: "",
                chatroomId: getChatRoomId(myName,users.keys.elementAt(index).toString()),
              );
        }) : Container();
  }

  

  getChatRoomId(String a, String b) {
    if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) { 
      return "$b\_$a";
    } else {
      return "$a\_$b";
    }
  }

  @override
  void initState() {
    super.initState();
  }



  @override

  Widget build(BuildContext context) {

  return Scaffold(
    
  appBar: AppBar(
      leading: IconButton(
    icon: Icon(Icons.arrow_back, color: Colors.black),
    onPressed: () => Navigate.pushPageReplacement(context, MainScreen()),
  ),
        title: TextField( 
          controller: searchEditingController,
          decoration: InputDecoration.collapsed(
            hintText: 'Search',
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.search
            ),
            onPressed: () {
              initiateSearch();
            },
          ),
        ]),
         body: isLoading ? Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      ) :
      Container (
        child: Column(
        children: [
          Container(
              color: Color(0x54FFFFFF),
          ),
          userList()

      ])));}
}
