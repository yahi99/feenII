import 'dart:async';

import 'package:feen/models/Geometry.dart';
import 'package:feen/models/PlaceResult.dart';
import 'package:feen/repository/PlaceRepository.dart';
import 'package:rxdart/rxdart.dart';

import 'Bloc.dart';

class BankBloc implements Bloc {
  Repository _repository;
  PublishSubject bankFetcher;
  static List<PlaceResult> bankList;

  Stream<List<PlaceResult>> get streamBankList => bankFetcher.stream;

  BankBloc(Location location, String bankName) {
    _repository = Repository();
    bankFetcher = PublishSubject<List<PlaceResult>>();
    bankList = List<PlaceResult>();
    fetchBank(location, bankName);
  }

  fetchBank(Location location, String bankName) async {
    List<PlaceResult> bankResponse =
        await _repository.fetchAtm(location, bankName);
    bankFetcher.sink.add(bankResponse);
    bankList = await _repository.fetchAtm(location, bankName);
  }

  @override
  void dispose() {
    bankFetcher.close();
  }
}
