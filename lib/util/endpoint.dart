class Endpoint {
  final String baseUrl = 'http://sqlbytnn.000webhostapp.com/';

  Uri getHistory() {
    return Uri.parse('$baseUrl/getHistory');
  }

  Uri getConfiguration() {
    return Uri.parse('$baseUrl/communication/configuration.json');
  }

  Uri getValveMode() {
    return Uri.parse('$baseUrl/ValveMode');
  }

  Uri getManualMode() {
    return Uri.parse('$baseUrl/ManualMode');
  }

  Uri getAutoMode() {
    return Uri.parse('$baseUrl/AutoMode');
  }

  Uri resetAlert() {
    return Uri.parse('$baseUrl/resetAlert');
  }
}
