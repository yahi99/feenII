import 'dart:convert';

import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResponse.dart';
import 'package:feen/network/API_KEY.dart';
import 'package:http/http.dart';

class ApiProvider {
  Client _client = Client();

  Future retrieveAtm(Location location, String bankName) async {
    print(bankName + " -----");
    final baseURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        "location=${location.lat},${location.long}&rankby=distance&type=atm&keyword=$bankName"
        "&key=$apiKey";

    final response = await _client.get(baseURL);
    print('Calling ATM API');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        return PlaceResponse.parseResults(data['results']);
      } else {
        throw Exception('An error occurred getting ATMs nearby');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }

  Future retrieveBank(Location location, String bankName) async {
    final baseURL =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        "location=${location.lat},${location.long}&rankby=distance&type=bank&keyword=$bankName"
        "&key=$apiKey";

    final response = await _client.get(baseURL);
    print('Calling bank API');

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        return PlaceResponse.parseResults(data['results']);
      } else {
        throw Exception('An error occurred getting banks nearby');
      }
    } else {
      throw Exception('Failed to load data');
    }
  }
}
