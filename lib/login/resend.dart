import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_x/login/confirm.dart';

class ResendPage extends StatefulWidget {
  const ResendPage({super.key});

  @override
  State<ResendPage> createState() => _ResendPageState();
}

class _ResendPageState extends State<ResendPage> {
  late TextEditingController emailController;

  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Project X'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 100),
            const Icon(Icons.security, size: 120, color: Colors.orange),
            const SizedBox(height: 32),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(double.infinity, 48),
              ),
              onPressed: () {
                resendCode(emailController.text);
              },
              child: const Text('Resend Code'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resendCode(String username) async {
    try {
      final result = await Amplify.Auth.resendSignUpCode(username: username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => ConfirmationPage()),
      );
    } on AuthException catch (e) {
      safePrint('Error resending code: $e');
    }
  }
}
