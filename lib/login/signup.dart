// ignore_for_file: use_build_context_synchronously

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_x/login/confirm.dart';
import 'package:project_x/login/login.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  late TextEditingController firstNameController;
  late TextEditingController lastNameController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    firstNameController = TextEditingController();
    lastNameController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Sign Up",
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
              Icons.app_registration_rounded,
            ),
            const SizedBox(height: 8),
            const Text(
              "Hi there!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Sign up for an account to join the cool kids club",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.normal,
              ),
            ),
            const SizedBox(height: 16),
            // First Name and Last Name
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: firstNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      labelText: "First Name",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Type your first name",
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
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: lastNameController,
                    decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(8)),
                      ),
                      contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                      labelText: "Last Name",
                      labelStyle: TextStyle(
                        fontSize: 12,
                        color: Theme.of(context).colorScheme.onBackground,
                        fontWeight: FontWeight.normal,
                      ),
                      hintText: "Type your last name",
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
                ),
              ],
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 8),
            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                border: const OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                ),
                contentPadding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                labelText: "Password",
                labelStyle: TextStyle(
                  fontSize: 12,
                  color: Theme.of(context).colorScheme.onBackground,
                  fontWeight: FontWeight.normal,
                ),
                hintText: "Type your password",
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
            // Sign Up Button
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
                signUpUser(passwordController.text, emailController.text,
                    firstNameController.text, lastNameController.text);
              },
              child: const Text(
                style: TextStyle(fontSize: 12),
                "Sign Up",
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signUpUser(
      String password, String email, String firstName, String lastName) async {
    try {
      final userAttributes = {
        AuthUserAttributeKey.givenName: firstName,
        AuthUserAttributeKey.familyName: lastName,
      };
      final result = await Amplify.Auth.signUp(
        username: email,
        password: password,
        options: SignUpOptions(
          userAttributes: userAttributes,
        ),
      );
      await _handleSignUpResult(result);
    } on AuthException catch (e) {
      safePrint('Error signing up user: ${e.message}');
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
