// ignore_for_file: use_build_context_synchronously

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:project_x/login/resend.dart';
import 'package:project_x/login/signup.dart';
import 'package:project_x/main.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "Login",
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
              Icons.login_rounded,
            ),
            const SizedBox(height: 8),
            const Text(
              "Welcome back!",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              "Login to your account to continue",
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
            // Login Button
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
                signInUser(emailController.text, passwordController.text);
              },
              child: const Text(
                style: TextStyle(fontSize: 12),
                "Login",
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              "Don't have an account?",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "What are you waiting for?",
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
                        builder: (context) => const SignUpPage(),
                      ),
                    );
                  },
                  child: Text(
                    "Register Now",
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

  Future<void> signInUser(String username, String password) async {
    try {
      final result = await Amplify.Auth.signIn(
        username: username,
        password: password,
      );
      if (result.nextStep.signInStep == AuthSignInStep.confirmSignUp) {
        await Amplify.Auth.resendSignUpCode(
          username: username,
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ResendPage()),
        );
      } else if (result.nextStep.signInStep == AuthSignInStep.done) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const MyApp()),
        );
      }
    } on AuthException catch (e) {
      safePrint('Error signing in: ${e.message}');
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
