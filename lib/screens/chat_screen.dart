import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String boardId;
  final String boardTitle;

  const ChatScreen({
    super.key,
    required this.boardId,
    required this.boardTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(boardTitle),
      ),
      body: Center(
        child: Text('Chat for $boardTitle'),
      ),
    );
  }
}
