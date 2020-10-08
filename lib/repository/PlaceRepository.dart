import 'package:feen/models/Geometry.dart';
import 'package:feen/network/ApiProvider.dart';

class Repository {
  ApiProvider _apiProvider = ApiProvider();

  Future fetchAtm(Location location, String bankName) =>
      _apiProvider.retrieveAtm(location, bankName);

  Future fetchBank(Location location, String bankName) =>
      _apiProvider.retrieveBank(location, bankName);
}
