import 'package:guru/services/api_service.dart';

class AuthService {

  static Future<Map<String, dynamic>> firebaseLogin(

      String email,

      ) async {

    return await ApiService.post(

      "/firebase-login",

      {

        "email": email,

      },

    );

  }

}