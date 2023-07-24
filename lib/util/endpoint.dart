class Endpoint {
  final String baseUrl = 'http://sqlbytnn.000webhostapp.com/';

  Uri getHistory({int page = 1, String status = 'published'}) {
    return Uri.parse('$baseUrl/getHistory');
  }
}
