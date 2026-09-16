import 'dart:math';

class Users {
  String userName;
  String gender;
  int age;
  double weight;
  bool isActive;

  Users(
    this.userName,
    this.age,
    this.weight,
    this.isActive, [
    this.gender = 'male',
  ]);

  String get name=>userName;

  set ageSeter(int age){
    if(age>18){
      print('agr is done');
    }else {
      print('negative age');
    }
  }

  Users fromJson(Map<String, dynamic> json) {
    return Users(
      json['userName'],
      json['gender'],
      json['age'],
      json['weight'],
      json['isActive'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userName': userName,
      'gender': gender,
      'age': age,
      'weight': weight,
      'isActive': isActive,
    };
  }
}

void main() {
  //Regex	Meaning
  // [0-9]	कोई भी number
  // [a-z]	lowercase letter
  // [A-Z]	uppercase letter
  // [a-zA-Z]	कोई भी English letter
  // [^0-9]	number के अलावा
  // \s	space/whitespace
  // .	कोई भी character
  // +	एक या ज्यादा
  // *	zero या ज्यादा
  String name='Sachin123';
  String name2='Sachin123ABC45';
  String name3='Sachin123@#';
  String name4='SachinKumar';

name=  name.replaceAll(RegExp(r'[0-9]'),'');
name2=  name2.replaceAll(RegExp(r'[^0-9]'),'');
name3=  name3.replaceAll(RegExp(r'[^a-zA-Z]'),'');
name3=  name4.replaceAll(RegExp(r'\s'),'');
print(name);
print(name2);
print(name3);
print(name4);

  // Random random = Random();
  //
  // int number = random.nextInt(10) + 1;
  //
  // print(number);

  // List userList = [
  //   Users('Sachin', 20, 60.50, false),
  //   Users('Aman', 24, 65.00, true),
  //   Users('Rahul', 35, 50.55, false, 'Female'),
  //   Users('Kapil', 12, 30.10, false),
  // ];

  // for (Users user in userList) {
  //   // Random random=  Random();
  //   print(
  //     'User:${user.userName},${user.gender},${user.age},${user.weight},${user.isActive}',
  //   );
  // }

  // User user = User.guest();
  //
  // print(user.name);

 //  Car car=Car(brand: 'BMW', module: 'S37', price: 5000000);
 //  print(car.brand);
 // // car.brand='aman';//ERROR
 //  print(car.brand);
}

class User {
  String name;
  int age;

  User(this.name, this.age);

  User.guest():name='guest',age=0;
}

class Car{
 final String brand;
  String module;
  int price;

  Car({
    required this.brand,
    required this.module,
    required this.price,
}){
    print('my car constructor');
  }


  factory Car.fromJson(Map<String,dynamic>json){
    return Car(brand: json['brand'], module: json['module'], price: json['price']);
  }

  Map<String,dynamic> toJson(){
    return {
      'brand':brand,
      'module':module,
      'price':price,
    };
  }

}
