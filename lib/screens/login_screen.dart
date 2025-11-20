import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailCtl = TextEditingController();
  final passCtl = TextEditingController();
  bool loading = false;
  String error = '';

  Future<void> _login() async {
    final email = emailCtl.text.trim();
    final pass = passCtl.text.trim();
    if (email.isEmpty || pass.isEmpty) {
      setState(() {
        error = 'Enter email and password';
      });
      return;
    }
    setState(() {
      loading = true;
      error = '';
    });
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: pass,
      );
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, '/redirect');
    } on FirebaseAuthException catch (e) {
      setState(() {
        loading = false;
        error = e.message ?? 'Login failed';
      });
    } catch (_) {
      setState(() {
        loading = false;
        error = 'Login failed';
      });
    }
  }

  void _goToRegister() {
    Navigator.pushNamed(context, '/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
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
              onPressed: loading ? null : _login,
              child: Text(loading ? 'Please wait' : 'Login'),
            ),
            TextButton(
              onPressed: _goToRegister,
              child: const Text('Create new account'),
            ),
          ],
        ),
      ),
    );
  }
}
