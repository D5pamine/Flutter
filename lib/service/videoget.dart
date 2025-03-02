import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class Videoget {
  final storage = const FlutterSecureStorage();

  /// 🚀 사용자 ID 기반으로 비디오 리스트 가져오기
  Future<dynamic> getUserVideo(String userId) async {
    await dotenv.load(fileName: '.env');
    String? token = await storage.read(key: "auth_token");

    if (token == null) {
      return {
        "statusCode": 401,
        "error": "❌ 인증 토큰이 없습니다. 다시 로그인하세요.",
      };
    }

    String serverUrl = dotenv.get("SERVER_URL", fallback: "NOT_FOUND");
    if (serverUrl == "NOT_FOUND") {
      return {
        "statusCode": 500,
        "error": "❌ SERVER_URL 환경 변수를 찾을 수 없습니다."
      };
    }

    String apiUrl = "$serverUrl/detected-videos/me"; // ✅ API URL 설정
    print("🔗 API 요청 URL: $apiUrl");
    print("🛡️ 사용 중인 인증 토큰: $token");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes);
        var res = jsonDecode(decodedBody);
        return {
          "statusCode": response.statusCode,
          "data": res,
        };
      } else {
        final errorMessage = utf8.decode(response.bodyBytes);
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

/// ✅ **비디오 스트리밍 API**
class VideoStream {
  final storage = const FlutterSecureStorage();

  /// 🚀 특정 `detectedId`의 스트리밍 URL 가져오기
  Future<String?> streamUserVideo(int detectedId) async {
    await dotenv.load(fileName: '.env');
    String? token = await storage.read(key: "auth_token");

    if (token == null) {
      return "❌ 인증 토큰이 없습니다. 다시 로그인하세요.";
    }

    String serverUrl = dotenv.get("SERVER_URL", fallback: "NOT_FOUND");
    if (serverUrl == "NOT_FOUND") {
      return "❌ SERVER_URL 환경 변수를 찾을 수 없습니다.";
    }

    String apiUrl = "$serverUrl/video-stream/$detectedId"; // ✅ detectedId 추가
    print("🔗 API 요청 URL: $apiUrl");
    print("🛡️ 사용 중인 인증 토큰: $token");
    // return apiUrl;
    return apiUrl;
    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        return response.body; // ✅ 스트리밍 URL 반환
      } else {

        final decodedBody = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩
        var res = jsonDecode(decodedBody); // ✅ JSON 변환

        print("📥 응답 데이터: $res"); // ✅ 한글 정상 표시 확인
        return null;
      }
    } catch (e) {
      print("❌ Exception in fetching video stream: $e");
      return null;
    }
  }
}

class VideoGetMe {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getMeVideos() async {
    await dotenv.load(fileName: '.env');
    String? token = await storage.read(key: "auth_token"); // ✅ 저장된 토큰 가져오기

    if (token == null) {
      return {
        "statusCode": 401,
        "error": "❌ 인증 토큰이 없습니다. 다시 로그인하세요.",
      };
    }

    String serverUrl = dotenv.get("SERVER_URL", fallback: "NOT_FOUND");
    if (serverUrl == "NOT_FOUND") {
      return {
        "statusCode": 500,
        "error": "❌ SERVER_URL 환경 변수를 찾을 수 없습니다.",
      };
    }

    String apiUrl = "$serverUrl/detected-videos/me";
    print("🔗 API 요청 URL: $apiUrl");
    print("🛡️ 사용 중인 인증 토큰: $token");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token", // ✅ 인증 토큰 포함
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        var res = jsonDecode(decodedBody); // ✅ JSON 변환

        print("✅ 비디오 데이터 수신: $res");

        return {
          "statusCode": response.statusCode,
          "data": res,
        };
      } else {
        final errorMessage = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        print("❌ API 요청 실패: $errorMessage");

        return {
          "statusCode": response.statusCode,
          "error": "❌ Failed to fetch user videos: $errorMessage",
        };
      }
    } catch (e) {
      print("❌ 요청 중 예외 발생: $e");

      return {
        "statusCode": 500,
        "error": "❌ 요청 중 예외 발생: ${e.toString()}",
      };
    }
  }
}

class VideoGetByViolation {
  final storage = const FlutterSecureStorage();

  Future<dynamic> getVideosByViolation(String violationType) async {
    await dotenv.load(fileName: '.env');
    String? token = await storage.read(key: "auth_token"); // ✅ 저장된 토큰 가져오기

    if (token == null) {
      return {
        "statusCode": 401,
        "error": "❌ 인증 토큰이 없습니다. 다시 로그인하세요.",
      };
    }

    String serverUrl = dotenv.get("SERVER_URL", fallback: "NOT_FOUND");
    if (serverUrl == "NOT_FOUND") {
      return {
        "statusCode": 500,
        "error": "❌ SERVER_URL 환경 변수를 찾을 수 없습니다.",
      };
    }

    // ✅ API 요청 URL 구성 (violation 파라미터 추가)
    String apiUrl = "$serverUrl/detected-videos/type?violation=$violationType";
    print("🔗 API 요청 URL: $apiUrl");
    print("🛡️ 사용 중인 인증 토큰: $token");

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token", // ✅ 인증 토큰 포함
        },
      );

      if (response.statusCode == 200) {
        final decodedBody = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        var res = jsonDecode(decodedBody); // ✅ JSON 변환

        print("✅ 비디오 데이터 수신: $res");

        return {
          "statusCode": response.statusCode,
          "data": res,
        };
      } else {
        final errorMessage = utf8.decode(response.bodyBytes); // ✅ UTF-8 디코딩 적용
        print("❌ API 요청 실패: $errorMessage");

        return {
          "statusCode": response.statusCode,
          "error": "❌ Failed to fetch videos by violation: $errorMessage",
        };
      }
    } catch (e) {
      print("❌ 요청 중 예외 발생: $e");

      return {
        "statusCode": 500,
        "error": "❌ 요청 중 예외 발생: ${e.toString()}",
      };
    }
  }
}