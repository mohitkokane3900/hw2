import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatScreen extends StatefulWidget {
  final String boardId;
  final String boardTitle;

  const ChatScreen({
    super.key,
    required this.boardId,
    required this.boardTitle,
  });

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final msgCtl = TextEditingController();
  final user = FirebaseAuth.instance.currentUser;

  Future<void> _send() async {
    final text = msgCtl.text.trim();
    if (text.isEmpty || user == null) return;

    await FirebaseFirestore.instance
        .collection('boards')
        .doc(widget.boardId)
        .collection('messages')
        .add({
      'text': text,
      'uid': user!.uid,
      'email': user!.email,
      'createdAt': FieldValue.serverTimestamp(),
    });

    setState(() {
      msgCtl.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final messagesRef = FirebaseFirestore.instance
        .collection('boards')
        .doc(widget.boardId)
        .collection('messages')
        .orderBy('createdAt', descending: true);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.boardTitle),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: messagesRef.snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final docs = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: docs.length,
                  itemBuilder: (context, index) {
                    final m = docs[index];
                    final text = m['text'] ?? '';
                    final email = m['email'] ?? '';
                    final ts = m['createdAt'];
                    String time = '';

                    if (ts != null) {
                      final dt = ts.toDate();
                      time =
                          '${dt.month}/${dt.day}/${dt.year} ${dt.hour}:${dt.minute.toString().padLeft(2, '0')}';
                    }

                    return ListTile(
                      title: Text(text),
                      subtitle: Text('$email • $time'),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: msgCtl,
                    decoration:
                        const InputDecoration(hintText: 'Enter a message'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _send,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
