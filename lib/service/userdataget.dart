import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class UserDataGet {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getUserInfo() async {
    await dotenv.load(fileName: '.env');
    String? token = await storage.read(key: "auth_token"); // ✅ 저장된 토큰 가져오기

    if (token == null) {
      return {
        "statusCode": 401,
        "error": "❌ 인증 토큰이 없습니다. 다시 로그인하세요.",
      };
    }

    print("Loaded SERVER_URL: ${dotenv.get("SERVER_URL", fallback: "NOT_FOUND")}");
    print("Using Token: $token"); // ✅ 디버깅을 위해 토큰 출력 (실제 앱에서는 로그 숨길 것)

    try {
      final response = await http.get(
        Uri.parse('${dotenv.get("SERVER_URL")}/user/user/info'),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token", // ✅ 토큰 추가
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        var res = jsonDecode(decodedBody); // ✅ JSON 변환
        return {
          "statusCode": response.statusCode,
          "data": res,
        };
      } else {
        final errorMessage = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        return {
          "statusCode": response.statusCode,
          "error": "❌ Failed to fetch user info: $errorMessage",
        };
      }
    } catch (e) {
      return {
        "statusCode": 500,
        "error": "❌ 요청 중 예외 발생: ${e.toString()}",
      };
    }
  }
}
