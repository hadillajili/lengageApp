import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:lengage_app/util/router.dart';
import 'package:lengage_app/views/widgets/post_item.dart';
import 'package:lengage_app/util/data.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:lengage_app/views/widgets/NewScreen.dart';
import 'auth/login.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  final auth = FirebaseAuth.instance;

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(
            Icons.filter_list,
          ),
          onPressed: () {},
        ),
        title: Text("Feeds"),
        centerTitle: true,
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              signOut();
            },
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Text(
                'Sign Out',
              ),
            ),
          ),
        ],
      ),
      body: ListView.builder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          Map post = posts[index];
          return PostItem(
            img: post['img'],
            name: post['name'],
            dp: post['dp'],
            time: post['time'],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          reminder();
        },
      ),
    );
  }

  Future<void> signOut() async {
    await auth
        .signOut()
        .then((value) => Navigate.pushPageReplacement(context, Login()));
  }

  Future<void> reminder() async {
    final scheduledNotificationDateTime = DateTime.now();
    final androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'channel id',
      'channel name',
      'channel description',
      icon: 'ic_launcher',
      largeIcon: DrawableResourceAndroidBitmap('ic_launcher'),
    );
    final iOSPlatformChannelSpecifics = IOSNotificationDetails();
    final platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
        iOS: iOSPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.periodicallyShow(
        0,
        'Looks like you liked this item',
        'Are you still interested to get it ? ',
        RepeatInterval.everyMinute,
        platformChannelSpecifics);
  }
}
