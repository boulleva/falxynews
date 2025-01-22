import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Anime & E-sport News'),
      ),
      body: Center(
        child: Text('Welcome to the News App!'),
      ),
    );
  }
}
