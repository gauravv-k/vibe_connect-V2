import 'dart:convert';
import 'package:http/http.dart' as http;

//Auth token we will use to generate a meeting and connect to it
String token =
    "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJhcGlrZXkiOiJiZmQ5NGM0Ni1jNDRkLTRkNWYtYjhmNS04YjIwNTJkNGYzYWUiLCJwZXJtaXNzaW9ucyI6WyJhbGxvd19qb2luIl0sImlhdCI6MTc1NDE5Nzk2MCwiZXhwIjoxNzYxOTczOTYwfQ.IZponcBDIwT8Ug3pOwMZ7L9JYTGpgocIsZQ4zoSWsz4";

// API call to create meeting
Future<String> createMeeting() async {
  final http.Response httpResponse = await http.post(
    Uri.parse("https://api.videosdk.live/v2/rooms"),
    headers: {'Authorization': token},
  );

//Destructuring the roomId from the response
  return json.decode(httpResponse.body)['roomId'];
}
