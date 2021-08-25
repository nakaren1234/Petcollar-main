import 'package:scoped_model/scoped_model.dart';

class UserModel extends Model {
  UserModel(this._userId);
  // User _currentUser;

  String _email;

  String _password;

  // String _phone;

  String _userId;

  double _lat = 0;

  double _lng = 0;

  // User get currentUser => _currentUser;

  String get email => _email;

  String get passowrd => _password;

  // String get phone => _phone;

  String get userId => _userId;

  double get lat => _lat;

  double get lng => _lng;

  // void setUser(User _currentUser) {
  //   this._currentUser = _currentUser;
  //   notifyListeners();
  // }

  void updateUserId(String _userId) {
    this._userId = _userId;
    notifyListeners();
    print("\n");
    print(_userId);
    print("\n");
  }

  void updateEmail(String _email) {
    this._email = _email;
    notifyListeners();
  }

  void updatePassword(String _password) {
    this._password = _password;
    notifyListeners();
  }

  // void updatePhone(String _phone) {
  //   this._phone = _phone;
  //   notifyListeners();
  // }

  void updateLat(double lat) {
    this._lat = lat;
    notifyListeners();
  }

  void updateLng(double lng) {
    this._lng = lng;
    notifyListeners();
  }
}
