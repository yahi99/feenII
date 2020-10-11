import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feen/models/PlaceResponse.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/network/Database.dart';
import 'package:feen/ui/screens/Dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import 'API_KEY.dart';

class MapService {
  //static UserData currentUser;
  static double latitude, longitude;
  static int distance;
  static List<PlaceResult> objectAtm, objectBank;
  static String bankKey = "null", atmKey = "null", keyword1 = "";
  static String keyword2 = "", keyword3 = "", keyword4 = "";
  static String keyword5 = "", keyword6 = "";
  static List<PlaceResult> places = new List<PlaceResult>();

  /*static getCurrentUser() async {
    currentUser = await Authnetwork().CurrentUser();
  }*/

  static setLocation(double lat, double lng) {
    latitude = lat;
    longitude = lng;
  }

  static checkTrisNumber() {
    //getCurrentUser();
    print("//////////////////////////////////");
    print(currentUser.triesNumber);
    if (currentUser.triesNumber > 3) {
      print('keteer ' + currentUser.triesNumber.toString());
      return false;
    } else {
      return true;
    }
  }

  static getNearbyAtm(String bankName, String operationType) async {
    objectAtm = List<PlaceResult>();
    DatabaseService.renewTriesNumber();
    objectAtm.clear();
    atmKey = "null";
    String _url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        "location=$latitude,$longitude&rankby=distance&type=atm&keyword=$bankName&key=$apiKey";
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        places =
            PlaceResponse.parseResults(data['results']).cast<PlaceResult>();
        for (int i = 0; i < places.length; i++) {
          getSimultaneousData(bankName, i, places[i].placeId);
        }
        if (operationType.contains("إيداع")) {
          List<PlaceResult> deposit = new List<PlaceResult>();
          objectAtm.forEach((f) {
            if (f.rating == 5) {
              deposit.add(f);
            }
          });
          objectAtm = deposit;
        }
      } else if (data['status'] == ("NOT_FOUND") ||
          data['status'] == ("ZERO_RESULTS")) {
        atmKey = "NOT_FOUND OR ZERO_RESULTS";
      } else if (data['status'] == ("OVER_QUERY_LIMIT")) {
        atmKey = "OVER_QUERY_LIMIT";
      }
    } else {
      atmKey = "other Error";
      throw Exception('An error occurred getting places nearby');
    }
    print("The Key is " + atmKey);
    return objectAtm;
  }

  static getNearbyBank(String bankName) async {
    objectBank = new List<PlaceResult>();
    objectBank.clear();
    bankKey = "null";
    String _url =
        "https://maps.googleapis.com/maps/api/place/nearbysearch/json?"
        "location=$latitude,$longitude&rankby=distance&type=bank&keyword=$bankName&key=$apiKey";
    final response = await http.get(_url);
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data['status'] == "OK") {
        bankKey = "Done";
        places =
            PlaceResponse.parseResults(data['results']).cast<PlaceResult>();
        for (int i = 0; i < places.length; i++) {}
      } else if (data['status'] == ("NOT_FOUND") ||
          data['status'] == ("ZERO_RESULTS")) {
        bankKey = "NOT_FOUND OR ZERO_RESULTS";
      } else if (data['status'] == ("OVER_QUERY_LIMIT")) {
        bankKey = "OVER_QUERY_LIMIT";
      }
    } else {
      bankKey = "other Error";
      throw Exception('An error occurred getting places nearby');
    }
    print("The Key is " + bankKey);
    return objectBank;
  }

  static getSimultaneousData(String bankName, int index, String atmID) {
    var now = DateTime.now();
    String currentDay = DateFormat('dd.MM.yyyy').format(now);
    String currentHour = "${now.hour.toString().padLeft(2, '0')}";
    Firestore.instance
        .collection('ATM')
        .document(bankName)
        .collection(atmID)
        .document(currentDay)
        .collection(currentHour)
        .snapshots()
        .listen((data) => data.documents.forEach((doc) {
              objectAtm[index].crowd = doc.data['crowd'];
              objectAtm[index].type = doc.data['type'];
              objectAtm[index].enoughMoney = doc.data['enoughMoney'];
//              objectAtm[index].rating = doc.data['rating'];
            }));
  }
}
