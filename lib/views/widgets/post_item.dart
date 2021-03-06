// @dart=2.9
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../main.dart';
import 'package:lengage_app/views/screens/home.dart';
import 'NewScreen.dart';

class PostItem extends StatefulWidget {
  final String dp;
  final String name;
  final String time;
  final String img;

  PostItem(
      {Key key,
      @required this.dp,
      @required this.name,
      @required this.time,
      @required this.img})
      : super(key: key);
  @override
  _PostItemState createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  Icon fav = Icon(
    Icons.shopping_bag_outlined,
    color: Colors.black54,
  );
  int favnumber = 0;
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: InkWell(
        child: Column(
          children: <Widget>[
            ListTile(
              leading: CircleAvatar(
                backgroundImage: AssetImage(
                  "${widget.dp}",
                ),
              ),
              contentPadding: EdgeInsets.all(0),
              title: Text(
                "${widget.name}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              trailing: Text(
                "${widget.time}",
                style: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                ),
              ),
            ),
            Image.asset(
              "${widget.img}",
              height: 170,
              width: MediaQuery.of(context).size.width,
              fit: BoxFit.cover,
            ),
            Text(
              "Item to Sell for 150£",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
              textAlign: TextAlign.start,
            ),
            FlatButton(
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "Save",
                      style: TextStyle(
                        color: Colors.black54,
                      ),
                    ),
                    fav,
                  ]),
              color: Colors.grey[200],
              onPressed: () => setState(() {
                if (favnumber == 0) {
                  fav = Icon(
                    Icons.shopping_bag,
                    color: Colors.green[400],
                  );
                  favnumber = 1;
                } else {
                  fav = Icon(
                    Icons.shopping_bag_outlined,
                    color: Colors.black54,
                  );
                  favnumber = 0;
                }
                notify('Item added to your list ');
              }),
            ),
          ],
        ),
        onTap: () {},
      ),
    );
  }

  Future<void> notify(String message) async {
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
    await flutterLocalNotificationsPlugin.schedule(0, 'Shopping cart', message,
        scheduledNotificationDateTime, platformChannelSpecifics);
  }
}
