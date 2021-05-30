import 'package:flutter/material.dart';
import 'package:lengage_app/views/screens/home.dart';

class NewScreen extends StatelessWidget {
  String payload;

  NewScreen({
    required this.payload,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(payload),
      ),
    );
  }
}
