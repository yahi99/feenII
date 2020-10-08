import 'dart:async';

import 'package:feen/blocs/Bloc.dart';
import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/repository/PlaceRepository.dart';
import 'package:rxdart/rxdart.dart';

class AtmBloc implements Bloc {
  Repository _repository;
  PublishSubject atmFetcher;
  static List<PlaceResult> atmList;

  Stream<List<PlaceResult>> get streamAtmList => atmFetcher.stream;

  AtmBloc(Location location, String bankName) {
    _repository = Repository();
    // atmList = List<PlaceResult>();
    atmFetcher = PublishSubject<List<PlaceResult>>();
    fetchAtm(location, bankName);
  }

  fetchAtm(Location location, String bankName) async {
    List<PlaceResult> atmResponse =
        await _repository.fetchAtm(location, bankName);
    atmFetcher.sink.add(atmResponse);
    // atmList = await _repository.fetchAtm(location, bankName);
  }

  @override
  void dispose() {
    atmFetcher.close();
  }
}
