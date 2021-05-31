import 'dart:math';

Random random = Random();
List names = [
  "Hadil Lajili",
  "Farah Tekaya",
  "Cyrine Gammoudi",
  "Aymen Hamadi",
  "Amani Miled",
  "Mohamed Magdiche",
  "Ines Bousrih",
  "Yassine Zakhama",
  "Wided oueslati",
  "Safa Daldoul",
  "Yosra Letaif",
];

List messages = [
  "Hey, how are you doing?",
  "Are you available tomorrow?",
  "It's late. Go to bed!",
  "This cracked me up 😂😂",
  "Flutter Rocks!!!",
  "The last rocket🚀",
  "Griezmann signed for Barca❤️❤️",
  "Will you be attending the meetup tomorrow?",
  "Are you angry at something?",
  "Let's make a UI serie.",
  "Can i hear your voice?",
];

List notifs = [
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} didn't accept your request yet",
  "${names[random.nextInt(10)]} Sent you a messsage",
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} didn't accept your request yet",
  "${names[random.nextInt(10)]} didn't accept your request yet",
  "${names[random.nextInt(10)]} started following you",
  "${names[random.nextInt(10)]} Sent you a friend request",
];

List notifications = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min ago",
          "notif": notifs[random.nextInt(10)]
        });

List posts = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "time": "${random.nextInt(50)} min ago",
          "img": "assets/images/dm${random.nextInt(10)}.jpg"
        });

List chats = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min ago",
          "isOnline": random.nextBool(),
        });

List groups = List.generate(
    13,
    (index) => {
          "name": "Group ${random.nextInt(20)}",
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "msg": messages[random.nextInt(10)],
          "counter": random.nextInt(20),
          "time": "${random.nextInt(50)} min ago",
          "isOnline": random.nextBool(),
        });

List types = ["text", "image"];
List conversation = List.generate(
    10,
    (index) => {
          "username": "Group ${random.nextInt(20)}",
          "time": "${random.nextInt(50)} min ago",
          "type": types[random.nextInt(2)],
          "replyText": messages[random.nextInt(10)],
          "isMe": random.nextBool(),
          "isGroup": false,
          "isReply": random.nextBool(),
        });

List friends = List.generate(
    13,
    (index) => {
          "name": names[random.nextInt(10)],
          "dp": "assets/images/cm${random.nextInt(10)}.jpeg",
          "status": "Anything could be here",
          "isAccept": random.nextBool(),
        });
