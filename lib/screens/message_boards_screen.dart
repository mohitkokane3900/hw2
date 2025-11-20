import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'profile_screen.dart';
import 'settings_screen.dart';
import 'chat_screen.dart';

class MessageBoardsScreen extends StatefulWidget {
  const MessageBoardsScreen({super.key});

  @override
  State<MessageBoardsScreen> createState() => _MessageBoardsScreenState();
}

class _MessageBoardsScreenState extends State<MessageBoardsScreen> {
  final boards = const [
    {'id': 'general_lounge', 'title': 'General Lounge'},
    {'id': 'homework_hub', 'title': 'Homework Hub'},
    {'id': 'exam_prep', 'title': 'Exam Prep Zone'},
    {'id': 'project_collab', 'title': 'Project Collaboration'},
    {'id': 'random_offtopic', 'title': 'Random Off-Topic'},
  ];

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
    if (!mounted) return;
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  void _openProfile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  void _openSettings() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SettingsScreen()),
    );
  }

  void _openBoard(Map<String, String> board) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChatScreen(
          boardId: board['id']!,
          boardTitle: board['title']!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Message Boards'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              child: Text('Menu'),
            ),
            ListTile(
              title: const Text('Message Boards'),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: const Text('Profile'),
              onTap: () {
                Navigator.pop(context);
                _openProfile();
              },
            ),
            ListTile(
              title: const Text('Settings'),
              onTap: () {
                Navigator.pop(context);
                _openSettings();
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pop(context);
                _logout();
              },
            ),
          ],
        ),
      ),
      body: ListView.builder(
        itemCount: boards.length,
        itemBuilder: (context, index) {
          final b = boards[index];
          return ListTile(
            leading: const Icon(Icons.forum),
            title: Text(b['title']!),
            onTap: () => _openBoard({
              'id': b['id']!,
              'title': b['title']!,
            }),
          );
        },
      ),
    );
  }
}
