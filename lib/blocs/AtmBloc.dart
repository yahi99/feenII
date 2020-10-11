import 'dart:async';

import 'package:feen/blocs/Bloc.dart';
import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/repository/PlaceRepository.dart';
import 'package:feen/ui/widgets/constants.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

class AtmBloc implements Bloc {
  Repository _repository;
  PublishSubject atmFetcher;
  static List<PlaceResult> atmList;
  List<String> keyword = List();

  Stream<List<PlaceResult>> get streamAtmList => atmFetcher.stream;

  AtmBloc(Location location, String bankName, String transaction) {
    _repository = Repository();
    // atmList = List<PlaceResult>();
    checkKeyword(bankName);
    atmFetcher = PublishSubject<List<PlaceResult>>();
    fetchAtm(location, bankName, transaction);
  }

  fetchAtm(Location location, String bankName, String transaction) async {
    print(bankName + "  " + transaction);
    List<PlaceResult> atmResponse =
        await _repository.fetchAtm(location, bankName);
    atmResponse = atmResponse.where((place) {
      place.distance = calculateDistance(location.lat, location.long,
              place.geometry.location.lat, place.geometry.location.long)
          .toStringAsFixed(1);
      return keyword.any((element) => place.name.contains(element));
    }).toList(growable: true);
    if (transaction == 'إيداع') {
      atmResponse =
          atmResponse.where((atm) => atm.rating == 5.0).toList(growable: true);
      print(atmResponse.length);
      Fluttertoast.showToast(
          msg: 'وجدنا ${atmResponse.length.toString()} ماكينات');
    }
    atmFetcher.sink.add(atmResponse);
    // atmList = atmResponse;
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

  bool getAtmName(PlaceResult place) {
    print(place.name);

    return keyword.any((element) => place.name.contains(element));
  }

  @override
  void dispose() {
    atmFetcher.close();
  }
}
