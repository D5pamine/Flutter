import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
  Future<dynamic> createUser({
    required var user_id,
    required var user_pw,
    required var username,
    required var email,
    required var phone,
    required var site_id,
    required var site_pw,
  }) async {
    await dotenv.load(fileName: '.env');
    print("Loaded SERVER_URL: ${dotenv.get("SERVER_URL", fallback: "NOT_FOUND")}");
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/auth/auth/signup'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": user_id,
        "user_pw": user_pw,
        "username": username,
        "email": email,
        "phone": phone,
        "site_id": site_id,
        "site_pw": site_pw,
      }),
    );

    var res = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "data": res,
    };
  }
}


class UserLoginService {
  final storage = const FlutterSecureStorage();

  Future<dynamic> loginUser({
    required var user_id,
    required var user_pw,
  }) async {
    await dotenv.load(fileName: '.env');
    print("Loaded SERVER_URL: ${dotenv.get("SERVER_URL", fallback: "NOT_FOUND")}");

    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/auth/login/user'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": user_id,
        "user_pw": user_pw,
      }),
    );

    var res = jsonDecode(response.body);

    if (response.statusCode == 200) {
      String token = res["access_token"];
      await storage.write(key: "auth_token", value: token); // ✅ 토큰 저장
    }

    return {
      "statusCode": response.statusCode,
      "data": res,
    };
  }
}

class ReportLoginService {
  Future<dynamic> reportLoginUser({
    required var user_id,
    required var user_pw,
  }) async {
    await dotenv.load(fileName: '.env');
    print("Loaded SERVER_URL: ${dotenv.get("SERVER_URL", fallback: "NOT_FOUND")}");
    final response = await http.post(
      Uri.parse('${dotenv.get("SERVER_URL")}/auth/login/user'),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "user_id": user_id,
        "user_pw": user_pw,
      }),
    );

    var res = jsonDecode(response.body);
    return {
      "statusCode": response.statusCode,
      "data": res,
    };
  }
}