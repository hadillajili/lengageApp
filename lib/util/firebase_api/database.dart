// @dart=2.9

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:translator/translator.dart';

class DatabaseMethods {
  Future<void> addUserInfo(userData) async {
    FirebaseFirestore.instance.collection("users").add(userData).catchError((e) {
      print(e.toString());
    });
  }

  getUserInfo(String email) async {
    return FirebaseFirestore.instance
        .collection("users")
        .where("userEmail", isEqualTo: email)
        .get()
        .catchError((e) {
      print(e.toString());
    });
  }

  searchByName(String searchField) async {
    var users = <dynamic>[];
    await FirebaseFirestore.instance
        .collection("users")
        .where('name', isEqualTo: searchField)
        .get()
        .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
            users.add(doc.data());
        });
    });

    return users;

    
  }

  Future<bool> addChatRoom(chatRoom, chatRoomId) async {
    var exists=await FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId).get();

    if (exists==null || exists.data()==null){
      FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(chatRoom)
        .catchError((e) {
      print(e);
    });
    
    } else{
       FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .set(exists.data())
        .catchError((e) {
      print(e);
    });
    }
  }

  getChats(String chatRoomId) async{
    
    Stream chats;
    chats = FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .orderBy('time') 
        .snapshots();
          return chats;

  }

  Future<void> addMessage(String chatRoomId, chatMessageData) async {
    var convo;

     await FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId).get().then((doc){
           doc.data();
           convo = doc.data();
        });

    convo['lastMsg']= chatMessageData;
    FirebaseFirestore.instance.collection("chatRoom")
    .doc(chatRoomId)
    .set(convo);

    FirebaseFirestore.instance.collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .add(chatMessageData).catchError((e){
          print(e.toString());
    });
  }
    

  getUserChats(String itIsMyName) async {
    return await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName)
        .snapshots();
        
  }



  updateTranslation(String lang,String itIsMyName) async {
    var userChats = <dynamic>[];
     await FirebaseFirestore.instance
        .collection("chatRoom")
        .where('users', arrayContains: itIsMyName) 
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            userChats.add(doc.data());
        });
        });

      for (var chat in userChats){
        this.changeTrans(lang, chat["chatRoomId"]);
      }       
  }

  changeTrans(String lang, String chatRoomId){
    final translator = GoogleTranslator();

    //translate the chat
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .collection("chats")
        .get()
        .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) async {
          var input =  doc.data()["translation"];
          doc.reference.update({
           'translation': '${await translator.translate(input,to: lang)}'
          });    
        });
        });
    //translate lastMsg
    FirebaseFirestore.instance
        .collection("chatRoom")
        .doc(chatRoomId)
        .get()
        .then((DocumentSnapshot doc) async {
          var input = doc.data()["lastMsg"]["translation"];
          doc.reference.update({
           'lastMsg.translation': '${await translator.translate(input,to: lang)}'
          });   
        });


  }

}