import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final firstCtl = TextEditingController();
  final lastCtl = TextEditingController();
  final roleCtl = TextEditingController(text: 'student');
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> _register() async {
    final first = firstCtl.text.trim();
    final last = lastCtl.text.trim();
    final role = roleCtl.text.trim().isEmpty ? 'student' : roleCtl.text.trim();
    final email = emailCtl.text.trim();
    final pass = passCtl.text.trim();

    if (first.isEmpty || last.isEmpty || email.isEmpty || pass.isEmpty) {
      setState(() {
        error = 'Fill in all fields';
      });
      return;
    }

    setState(() {
      loading = true;
      error = '';
    });

    try {
      final cred = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: pass,
      );
      final user = cred.user;
      if (user != null) {
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'uid': user.uid,
          'firstName': first,
          'lastName': last,
          'email': email,
          'role': role,
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/redirect');
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
        error = e.message ?? 'Registration failed';
      });
    } catch (_) {
      setState(() {
        loading = false;
        error = 'Registration failed';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: firstCtl,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              TextField(
                controller: lastCtl,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              TextField(
                controller: roleCtl,
                decoration: const InputDecoration(labelText: 'Role'),
              ),
              TextField(
                controller: emailCtl,
                decoration: const InputDecoration(labelText: 'Email'),
                keyboardType: TextInputType.emailAddress,
              ),
              TextField(
                controller: passCtl,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
              const SizedBox(height: 12),
              if (error.isNotEmpty)
                Text(
                  error,
                  style: const TextStyle(color: Colors.red),
                ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: loading ? null : _register,
                child: Text(loading ? 'Please wait' : 'Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
