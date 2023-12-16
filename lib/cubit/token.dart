// ignore_for_file: deprecated_member_use

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';

class TokenCubit extends Cubit<String?> {
  TokenCubit() : super(null);

  Future<void> getToken() async {
    final session = await Amplify.Auth.fetchAuthSession(
      options: const CognitoSessionOptions(getAWSCredentials: true),
    );
    AWSCognitoUserPoolTokens awsCognitoUserPoolTokens =
        (session as CognitoAuthSession).userPoolTokens!;
    emit(awsCognitoUserPoolTokens.accessToken.raw);
  }
}
