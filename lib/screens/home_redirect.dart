import 'package:flutter/material.dart';

class HomeRedirect extends StatelessWidget {
  const HomeRedirect({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text('Logged in. Message boards will go here.'),
      ),
    );
  }
}
