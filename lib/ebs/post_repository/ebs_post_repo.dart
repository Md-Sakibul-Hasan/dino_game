import 'dart:convert';

import 'package:oauth2/oauth2.dart' as oauth2;
class EbsPostRepo{
  static Future<void> postScoreData({
    required int gameScore,
    required String userId,
    int? gameLevel,
  }) async {
    var scoreMap = {
      "game_id": 1,
      "name": "dino_run",
      "score": gameScore,
      "user_id": userId
    };

    var response = await post(data: jsonEncode(scoreMap));
    print("post score response=$response");

  }

  static Future<dynamic> post({required data}) async {
    Uri authorizationEndpoint = Uri.parse("https://idpific.oss.net.bd/realms/test/protocol/openid-connect/token");
    const identifier = "nodejs-app-client";
    const secret = "KZyJQPa01R01H6aNnRvRcD9sCDkPnkjX";
    try {
      var client = await oauth2.clientCredentialsGrant(authorizationEndpoint, identifier, secret).timeout(const Duration(seconds: 30));
      final response = await client
          .post(Uri.parse('https://event-feedback.ba-systems.com/api/v2/users/v1/insert/score'),
          headers: {
            'Content-type': 'application/json',
            'Accept': 'application/json',
          },
          body: data)
          .timeout(
        const Duration(seconds: 120),
      );

      return response;
    }catch(e,s){
      print("failed to post score=$e");
      print("failed to post stacktrace=$s");
    }
  }

}