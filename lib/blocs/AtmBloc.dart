import 'dart:async';

import 'package:feen/blocs/Bloc.dart';
import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/repository/PlaceRepository.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AtmBloc implements Bloc {
  Repository _repository;
  PublishSubject atmFetcher;
  static List<PlaceResult> atmList;
  List<String> keyword = List();
  int trialNumber = 0;

  Stream<List<PlaceResult>> get streamAtmList => atmFetcher.stream;

  AtmBloc(Location location, String bankName, String transaction) {
    _repository = Repository();
    checkKeyword(bankName);
    atmFetcher = PublishSubject<List<PlaceResult>>();
    _checkTrialNo(location, bankName, transaction);
  }

  fetchRealTimeAtm(
      Location location, String bankName, String transaction) async {
    List<PlaceResult> _result = await _repository.fetchAtm(location, bankName);
    _result = _result.where((place) {
      place.distance = calculateDistance(location.lat, location.long,
              place.geometry.location.lat, place.geometry.location.long)
          .toStringAsFixed(1);
      return keyword.any((element) => place.name.contains(element));
    }).toList(growable: true);
    if (transaction == 'إيداع') {
      _result =
          _result.where((atm) => atm.rating == 5.0).toList(growable: true);
      atmFetcher.sink.add(_result);
    } else {
      atmFetcher.sink.add(_result);
    }
    Fluttertoast.showToast(msg: 'وجدنا ${_result.length.toString()} ماكينات');
    atmList = List<PlaceResult>();
    atmList = _result;
    _incrementCounter();
  }

  fetchCachedAtm(String transaction) async {
    if (atmList.length == 0)
      Fluttertoast.showToast(
          msg:
              "عذرًا، لقد استهلكت المحاولات المجانية، سيتم تجديدها في اليوم التالي.",
          toastLength: Toast.LENGTH_LONG);

    if (transaction == 'إيداع') {
      atmList =
          atmList.where((atm) => atm.rating == 5.0).toList(growable: true);
      atmFetcher.sink.add(atmList);
    } else {
      atmFetcher.sink.add(atmList);
    }
  }

  _incrementCounter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trialNumber = (prefs.getInt('trialNumber') ?? 0) + 1;
    prefs.setInt('trialNumber', trialNumber);
    print(trialNumber.toString() + "   ***********");
  }

  _checkTrialNo(Location location, String bankName, String transaction) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    trialNumber = (prefs.getInt('trialNumber') ?? 0);
    print(trialNumber.toString() + "   ///////");
    if (trialNumber < 3) {
      fetchRealTimeAtm(location, bankName, transaction);
    } else {
      fetchCachedAtm(transaction);
    }
  }

  checkKeyword(String bankName) {
    if (bankName.contains("البنك الأهلي المصري")) {
      keyword = [
        'الأهلي المصري',
        'الأهلى المصري',
        'الأهلي المصرى',
        'الأهلى المصرى',
        'بنك الاهلي',
        'بنك الاهلى',
        'National Bank Of Egypt',
        'NBE',
        'Nbe',
        'Ahly',
      ];
    } else if (bankName == "بنك مصر") {
      keyword = [
        'بنك مصر',
        'Banque Misr',
        'Banquemisr',
        'maser',
        'Bank of Egypt',
        'Misr Bank',
        'Ahly',
      ];
    } else if (bankName == "بنك القاهرة") {
      keyword = [
        'بنك القاهرة',
        'Banque du caire',
        'Banque Du Caire',
        'Cairo Bank',
        'El Qahra',
        'El Kahra',
        'Al Qahera',
      ];
    }
  }

  @override
  void dispose() {
    atmFetcher.close();
  }
}
