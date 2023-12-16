// ignore_for_file: use_build_context_synchronously

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
        title: const Text(
          "Resend Code",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          children: [
            const SizedBox(height: 48),
            const Icon(
              size: 128,
              Icons.password_rounded,
            ),
            const SizedBox(height: 8),
            const Text(
              "Request a new code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Give us your email to receive a new code",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            // Email
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Email",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Type your email",
                hintStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
              ),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onBackground,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            // Resend Code Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                minimumSize: const Size(96, 48),
                maximumSize: const Size(96, 48),
                padding: const EdgeInsets.all(0),
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                backgroundColor: Theme.of(context).colorScheme.primary,
              ),
              onPressed: () {
                resendCode(emailController.text);
              },
              child: const Text(
                style: TextStyle(fontSize: 12),
                "Resend",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> resendCode(String username) async {
    try {
      await Amplify.Auth.resendSignUpCode(username: username);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ConfirmationPage()),
      );
    } on AuthException catch (e) {
      safePrint('Error resending code: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message,
            style: TextStyle(
              color: Theme.of(context).colorScheme.onError,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    }
  }
}
