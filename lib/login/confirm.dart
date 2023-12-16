// ignore_for_file: use_build_context_synchronously

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_x/login/login.dart';
import 'package:project_x/login/resend.dart';

class ConfirmationPage extends StatefulWidget {
  const ConfirmationPage({super.key});

  @override
  State<ConfirmationPage> createState() => _ConfirmationPageState();
}

class _ConfirmationPageState extends State<ConfirmationPage> {
  late TextEditingController emailController;
  late TextEditingController codeController;

  @override
  void initState() {
    emailController = TextEditingController();
    codeController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Confirm Account",
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
              Icons.mark_email_read_rounded,
            ),
            const SizedBox(height: 8),
            const Text(
              "Check your email!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "We sent you a confirmation code",
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
            const Text(
              "Your code should be comprised of 6 digits",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "It may take a few minutes to arrive",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 8),
            // Code
            TextField(
              controller: codeController,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Code",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Type your code",
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
            // Submit Button
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
                confirmUser(emailController.text, codeController.text);
              },
              child: const Text(
                style: TextStyle(fontSize: 12),
                "Confirm",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Didn't receive the code?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Skill issue.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.normal,
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ResendPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Resend Code",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> confirmUser(String username, String confirmationCode) async {
    try {
      final result = await Amplify.Auth.confirmSignUp(
        username: username,
        confirmationCode: confirmationCode,
      );
      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error confirming user: ${e.message}');
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

  Future<void> _handleSignUpResult(SignUpResult result) async {
    switch (result.nextStep.signUpStep) {
      case AuthSignUpStep.confirmSignUp:
        final codeDeliveryDetails = result.nextStep.codeDeliveryDetails!;
        _handleCodeDelivery(codeDeliveryDetails);
        break;
      case AuthSignUpStep.done:
        safePrint('Sign up is complete');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginPage()),
        );
        break;
    }
  }

  void _handleCodeDelivery(AuthCodeDeliveryDetails codeDeliveryDetails) {
    safePrint(
      'A confirmation code has been sent to ${codeDeliveryDetails.destination}. '
      'Please check your ${codeDeliveryDetails.deliveryMedium.name} for the code.',
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const ConfirmationPage()),
    );
  }
}
