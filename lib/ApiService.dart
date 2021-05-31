import 'package:http/http.dart' as http;
Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse('https://lengage.herokuapp.com/post/60b4ddf64d813f7b610fb464'));
}