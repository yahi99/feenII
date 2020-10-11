import 'dart:async';

import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/repository/PlaceRepository.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Bloc.dart';

class BankBloc implements Bloc {
  Repository _repository;
  PublishSubject bankFetcher;
  static List<PlaceResult> bankList;
  int trialNumber = 0;

  Stream<List<PlaceResult>> get streamBankList => bankFetcher.stream;

  BankBloc(Location location, String bankName) {
    _repository = Repository();
    bankFetcher = PublishSubject<List<PlaceResult>>();
    _checkTrialNo(location, bankName);
  }

  fetchRealTimeBank(Location location, String bankName) async {
    List<PlaceResult> _result = await _repository.fetchBank(location, bankName);
    _result = _result.map((bank) {
      bank.distance = calculateDistance(location.lat, location.long,
              bank.geometry.location.lat, bank.geometry.location.long)
          .toStringAsFixed(1);
    }).toList(growable: true);

    bankFetcher.sink.add(_result);
    Fluttertoast.showToast(msg: 'وجدنا ${_result.length.toString()} فروع');
    bankList = List<PlaceResult>();
    bankList = _result;
    _incrementCounter();
  }

  fetchCachedBank() async {
    if (bankList.length == 0)
      Fluttertoast.showToast(
          msg:
              "عذرًا، لقد استهلكت المحاولات المجانية، سيتم تجديدها في اليوم التالي.",
          toastLength: Toast.LENGTH_LONG);

    bankFetcher.sink.add(bankList);
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trialNumber = (prefs.getInt('trialNumber') ?? 0) + 1;
    prefs.setInt('trialNumber', trialNumber);
    print(trialNumber.toString() + "   ***********");
  }

  _checkTrialNo(Location location, String bankName) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trialNumber = (prefs.getInt('trialNumber') ?? 0);
    if (trialNumber < 15) {
      print(trialNumber.toString() + "   lesa");
      fetchRealTimeBank(location, bankName);
    } else {
      print(trialNumber.toString() + "   khalas");
      fetchCachedBank();
    }
  }

  @override
  void dispose() {
    bankFetcher.close();
  }
}
