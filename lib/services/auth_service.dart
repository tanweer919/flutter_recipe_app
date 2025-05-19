import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/models/user.dart';
import 'package:dekorner_recipe/services/get_it_locator.dart';
import 'package:dekorner_recipe/services/http_service.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  HttpService httpService = locator<HttpService>();
  LocalStorageService localStorageService = LocalStorageService();
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

  Future<User?> getCurrentUser() async {
    try {
      final httpClient = await httpService.getAuthenticatedApiClient();
      final response = await httpClient.post('$baseUrl/api/auth/current_user/');
      if (response.statusCode == 200) {
        final data = response.data;
        return User.fromJson(data);
      } else {
        return null;
      }
    } catch (error) {
      return null;
    }
  }

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      return {
        'accessToken': googleAuth.accessToken,
        'idToken': googleAuth.idToken,
      };
    } catch (error) {
      throw Exception('Google login failed');
    }
  }

  Future<User> loginWithGoogle() async {
    try {
      final FirebaseAuth _auth = FirebaseAuth.instance;
      final httpClient = await httpService.getApiClient();
      final googleAuth = await signInWithGoogle();
      final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth['accessToken'],
          idToken: googleAuth['idToken']);

      final authResult = await _auth.signInWithCredential(credential);
      final user = authResult.user;
      if (user == null) {
        throw Exception('Failed to authenticate');
      }
      final token = await user.getIdToken();
      final response = await httpClient.post(
        '$baseUrl/api/auth/google/',
        data: {
          'id_token': token,
        },
      );
      if (response.statusCode == 200) {
        final data = response.data;
        await localStorageService.setAuthToken(
            accessToken: data['access'], refreshToken: data['refresh']);
        return User.fromJson(data['user']);
      } else {
        throw Exception('Failed to authenticate with backend');
      }
    } catch (error) {
      throw Exception(error.message);
    }
  }
}

extension on Object {
   get message => null;
}
