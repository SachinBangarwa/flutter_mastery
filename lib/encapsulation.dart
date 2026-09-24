class User {
  String _name;

  String get name => _name;

  User(this._name);

  set name(String name) {
    if (name.isNotEmpty) {
      _name = name;
    } else {
      print('your name is empty');
    }
  }
}

void main() {
  final user = ('Sachin', 20);
  print(user.$1);
  print(user.$2);
  //Records ka main purpose
  ({bool valid, String msg}) getEmailCheck(String email) {
    if (email.contains('@')) {
      return (valid: true, msg: 'email is valid');
    } else {
      return (valid: false, msg: 'email is not valid');
    }
  }
  // final (:valid,:msg)= getEmailCheck('Sachin@gmail.com');
  //
  // print(valid);
  // print(msg);

  final value = getEmailCheck('Sachin@gmail.com');

  print(value.valid);
  print(value.msg);

  String name = 'sachin';

  print(name.capitalize());
  DateTime date=DateTime.now();
  print(date.currentDate);
}

extension StringExtension on String {
  String capitalize() {
    if (isEmpty) {
      return this;
    }
    return this[0].toUpperCase() + substring(1);
  }
}

extension DateFormat on DateTime {
  bool get currentDate {
    final now = DateTime.now();
    return year == now.year && month == now.month && day == now.day;
  }
}
