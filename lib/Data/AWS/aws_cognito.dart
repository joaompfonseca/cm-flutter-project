import 'package:amazon_cognito_identity_dart_2/cognito.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AWSServices {
  final userPool = CognitoUserPool(
    dotenv.env['COGNITO_USERPOLL_ID']!,
    dotenv.env['COGNITO_APP_CLIENT_ID']!,
  );

  late CognitoUserSession? session;

  Future createInitialRecord(email, password) async {
    var done = false;
    debugPrint("Authenticating user...");
    final cognitoUser = CognitoUser(email, userPool);
    final authDetails = AuthenticationDetails(
      username: email,
      password: password,
    );
    CognitoUserSession? sessiont;
    try {
      sessiont = await cognitoUser.authenticateUser(authDetails);
      session = sessiont;
      done = true;
      debugPrint("Login Success...");
    } on CognitoUserNewPasswordRequiredException catch (e) {
      debugPrint('CognitoUserNewPasswordRequiredException $e');
    } on CognitoUserMfaRequiredException catch (e) {
      debugPrint('CognitoUserMfaRequiredException $e');
    } on CognitoUserSelectMfaTypeException catch (e) {
      debugPrint('CognitoUserMfaRequiredException $e');
    } on CognitoUserMfaSetupException catch (e) {
      debugPrint('CognitoUserMfaSetupException $e');
    } on CognitoUserTotpRequiredException catch (e) {
      debugPrint('CognitoUserTotpRequiredException $e');
    } on CognitoUserCustomChallengeException catch (e) {
      debugPrint('CognitoUserCustomChallengeException $e');
    } on CognitoUserConfirmationNecessaryException catch (e) {
      debugPrint('CognitoUserConfirmationNecessaryException $e');
    } on CognitoClientException catch (e) {
      debugPrint('CognitoClientException $e');
    } catch (e) {
      print(e);
    }
    return done;
  }

  Future signup(firstName, lastName, email, password) async {
    var done = false;
    final userAttributes = [
      AttributeArg(name: 'given_name', value: firstName),
      AttributeArg(name: 'family_name', value: lastName),
    ];

    var data;
    try {
      data = await userPool.signUp(email, password,
          userAttributes: userAttributes);
      done = true;
      debugPrint("Signup Success...");
    } catch (e) {
      print(e);
    }
    return done;
  }

  Future confirm(email, code) async {
    var done = false;
    final cognitoUser = CognitoUser(email, userPool);
    try {
      await cognitoUser.confirmRegistration(code);
      done = true;
      debugPrint("Confirm Success...");
    } catch (e) {
      print(e);
    }
    return done;
  }

  Future resend(email) async {
    var done = false;
    final cognitoUser = CognitoUser(email, userPool);
    try {
      await cognitoUser.resendConfirmationCode();
      done = true;
      debugPrint("Resend Success...");
    } catch (e) {
      print(e);
    }
    return done;
  }
}
