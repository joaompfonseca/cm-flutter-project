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

  ProfileState({
    required this.profile,
    required this.tokenCubit,
  });
}

class ProfileCubit extends Cubit<ProfileState> {
  final String gwDomain = dotenv.env['GW_DOMAIN']!;

  ProfileCubit(profile) : super(profile);

  Future<bool> getProfile() async {
    // Get Token
    await state.tokenCubit.getToken();

    final response = await get(
      Uri.https(
        gwDomain,
        "api/user",
      ),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
    );
    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      final profile = Profile.fromJson(data);
      emit(ProfileState(
        profile: profile,
        tokenCubit: state.tokenCubit,
      ));
      return true;
    } else {
      return false;
    }
  }

  Future<void> createProfile(String email, String username, String firstName,
      String lastName, String birthDate) async {
    final uri = Uri.https(gwDomain, 'api/auth/register');

    final response = await post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode({
        'email': email,
        'username': username,
        'first_name': firstName,
        'last_name': lastName,
        'birth_date': birthDate,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      getProfile();
    } else {
      throw Exception('Failed to create profile');
    }
  }

  Future<void> updateProfile(String username, File? image) async {
    final uri = Uri.https(gwDomain, 'api/user/edit');

    var data = {};

    if (username != "") {
      data['username'] = username;
    }
    if (image != null) {
      final imageUrl = await uploadImage(image);
      data['image_url'] = imageUrl;
    }

    final response = await put(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode(data),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      getProfile();
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<String> uploadImage(File image) async {
    final uri = Uri.https(gwDomain, 'api/s3/upload');

    //convert image to base64 string
    List<int> imageBytes = image.readAsBytesSync();
    String base64Image = base64Encode(imageBytes);

    //get image type
    String temp = image.path.split('.').last;
    String imageType = "image/$temp";

    safePrint(base64Image);

    final response = await post(
      uri,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.authorizationHeader: 'Bearer ${state.tokenCubit.state}',
      },
      body: jsonEncode({
        'base64_image': base64Image,
        'image_type': imageType,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      safePrint(data);
      //change image url of saved profile
      emit(ProfileState(
          profile: Profile(
            id: state.profile.id,
            email: state.profile.email,
            username: state.profile.username,
            firstName: state.profile.firstName,
            lastName: state.profile.lastName,
            birthDate: state.profile.birthDate,
            pictureUrl: data['image_url'],
            cognitoId: state.profile.cognitoId,
            createdAt: state.profile.createdAt,
            totalXp: state.profile.totalXp,
            addedPoisCount: state.profile.addedPoisCount,
            givenRatingsCount: state.profile.givenRatingsCount,
            receivedRatingsCount: state.profile.receivedRatingsCount,
          ),
          tokenCubit: state.tokenCubit));
      return data['image_url'];
    } else {
      throw Exception('Failed to upload image');
    }
  }
}
