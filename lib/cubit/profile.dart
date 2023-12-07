import 'dart:io';

import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project_x/cubit/token.dart';
import 'package:project_x/profile/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart';
import 'dart:convert';

class ProfileState {
  final Profile profile;
  final TokenCubit tokenCubit;

  ProfileState(
    this.profile,
    this.tokenCubit,
  );
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(profile) : super(profile);

  final String apiUrl = dotenv.env['API_URL']!;

  Future<void> getProfile() async {
    // Get Token
    await state.tokenCubit.getToken();

    final response = await get(
      Uri.parse(apiUrl + '/user'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      safePrint(data);
      final profile = Profile.fromJson(data);
      emit(ProfileState(profile, state.tokenCubit));
    } else {
      throw Exception('Failed to load profile');
    }
  }
}
