import 'package:dekorner_recipe/constants.dart';
import 'package:dekorner_recipe/services/http_service.dart';
import 'package:dekorner_recipe/services/local_storage_service.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  HttpService httpService;
  LocalStorageService localStorageService;
  AuthService({required this.httpService, required this.localStorageService});
  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email', 'profile'],
  );

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
      throw Exception('Google sign in failed: $error');
    }
  }

  Future<Map<String, dynamic>> loginWithGoogle() async {
    final httpClient = await httpService.getApiClient();
    final googleAuth = await signInWithGoogle();
    final response = await httpClient.post(
      '$baseUrl/api/auth/google/',
      data: {
        'id_token': googleAuth['idToken'],
      },
    );
    final data = response.data;
    await localStorageService.setAuthToken(
        accessToken: data['access_token'], refreshToken: data['refresh_token']);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to authenticate with backend');
    }
  }
}
