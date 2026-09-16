import 'dart:io';
import 'package:flutter/material.dart';
import 'floatoon/demo/floatoon_demo_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FloatoonApp());
}

class FloatoonApp extends StatelessWidget {
  const FloatoonApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Floatoon Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6D28D9)),
        useMaterial3: true,
      ),
      home: const FloatoonDemoScreen(),
    );
  }
}


  // print(OrderStatus.pending.label);
  // fun();
  // variable();
  // search();
  // contains();
  // split();
  // join();
  // loops();
  //  practice();
  //
  //  function('Sachin', 20, 20.5);
  //  function2("amit", 23,20.2);
  //  function3(name: 'ajay',age: 33,weight: 55.55);
  //  function4(age: 22);
  // int outPut= square(20,40);
  // print(outPut);
  //  collection();
  // test();
// }

void variable() {
  String name = 'my name Is sachin!';
  int age = 20;
  double weight = 55.50;
  bool isActive = false;

  name = name.toLowerCase();
  // name=name.toUpperCase();
  print(
    name.contains('is'),
  ); //The method 'contains' isn't defined for the type int,double,bool
  //outPut:true

  name = name.replaceAll('!', '.');
  // name=name.replaceFirst('is','IS');
  // name=name.replaceAllMapped();
  name = name.replaceRange(0, 7, 'He');

  print(name);
  //output:my name is sachin.
}

void search() {
  String name =
      'aman,sachin,raja,vasu,payal,komal,sonu,shuhani,ankit,aman,dinesh';
  String searchV = "ajay";
  if (name.toLowerCase().contains(searchV)) {
    print('found');
  } else {
    print("Not found");
  }
}

void contains() {
  String file = '"C:/Users/Sachin/Downloads/workbook_door.png.png"';
  String url =
      "http://www.google.com/search?q=flutter+sdk&oq=&gs_lcrp=EgZjaHJvbWUqCQgDECMYJxjqAjIJCAAQIxgnGOoCMgkIARAjGCcY6gIyCQgCECMYJxjqAjIJCAMQIxgnGOoCMgkIBBAjGCcY6gIyCQgFECMYJxjqAjIJCAYQIxgnGOoCMgkIBxAjGCcY6gLSAQ03MTg2OTI3MDZqMGo3qAIIsAIB8QXPar9vZU4AJA&sourceid=chrome&source=chrome.ob&ie=UTF-8";
  if (url.startsWith("http://")) {
    url = url.replaceFirst('http://', "https://");
    print(url);
  }

  file = file.replaceAll('"', '');

  if (file.endsWith('png.png')) {
    file = file.replaceAll('png.png', 'png');
    print(file);
  }

  String phone = "987-654-3210";
  phone = phone.trim();
  phone = phone.replaceAll("-", "");

  print(phone);

  String text = "   Sachin   ";

  print(text.trim());

  String val = 'Token asdfh83nsdfa8awnak';
  print(val.substring(0, 6));
  print(val.substring(6));
}

void split() {
  String fullName = "Sachin Bangarwa";
  String url = "https://example.com/products/123";
  String data = "Sachin,Flutter,Developer";

  List<String> values = data.split(",");
  List<String> parts = fullName.split(" ");
  List<String> pat = url.split("/");
  print(parts);
  print(pat);
  print(values);
}

void join() {
  List<String> names = ["Sachin", "Rahul", "Amit"];

  String result = names.join(", ");
  print(result);
  indexOf();
}

void indexOf() {
  String email = "sachin@gmail.com";

  print(email.indexOf("@"));

  String path = "user/profile/image.jpg";
  //Ye last / ka position dega.
  print(path.lastIndexOf("/"));
  pad();
}

void pad() {
  String number = "18";

  print(number.padLeft(5, "0"));
  print(number.padRight(10, "0"));

  String x = "Flutter Flutter Dart";

  print(x.indexOf("Flutter"));
  print(x.lastIndexOf("Flutter"));
  String y = "A,B,C,D";

  print(y.split(",").length);
  String z = "Sachin";

  print(z.substring(0, 3));
  arithMetic();
}

void arithMetic() {
  int a = 7;
  int b = 40;
  print("${a + b},${a - b},${a * b},${a / b},${a ~/ b},${a % b}");

  if (a % 2 == 0) {
    print('even $a');
  } else {
    print('odd $a');
  }

  int val = -20; //nagitive ko htana
  print(val.abs());
  //20

  rfc();
}

void rfc() {
  double rating = 4.5; //yani .5 h ya se bda h to 5 manega nhi to 4
  print(rating.round());
  //5

  int products = 21;
  int perPage = 10;

  int pages = (products / perPage)
      .ceil(); //yani . se koi mtlb nhi h agr . mavalue h to auko full manega 4.1 h to isko 5 manega
  //21 / 10 = 2.1
  // ceil()   = 3
  print(pages);
  //3

  double number = 4.7;

  print(number.round()); // 5
  print(number.floor()); // 4
  print(number.ceil()); // 5
  ende();
}

void ende() {
  int a = 10;
  int b = 20;
  int c = 15;
  a = b++;
  b = ++a;
  print("a:$a,b:$b");

  // int d=(++a)+(c--);
  // d++;
  // int e=c++;
  // int f=c+d;
  // int g=a>b?++b:b++;
  // int h=g+e;
  // int i=(c--)+(++h)+a;
  //
  // print('a:$a');
  // print('b:$b');
  // print('c:$c');
  // print('d:$d');
  // print('e:$e');
  // print('f:$f');
  // print('g:$g');
  // print('h:$h');
  // print('i:$i');

  //a=11
  //b=21
  //c=14
  //d=27
  //e=14
  //f=42
  //g=20
  //h=35
  //i=61
}

void loops() {
  // int i=0;
  // print('start');
  // while(i<=5){
  //   print('i:$i');
  //   i++;
  //   //0,1,,2,3,4,5
  // }
  // print('end');

  // do{
  //   print('i:$i');
  //   i++;
  // }while(i<=10);
  // print('start');
  // for (int i = 1; i <= 10; i++) {
  //   print(2 * i);
  // }
  // print('end');

  List<String> list = ['Sachin', 'Amit', 'Ankit', 'Rahul'];

  Set<String> names = {'amit', 'ankit', 'rahul'};
  //
  // for(String oneItem in list){
  //   print(oneItem);
  // }
  // for(String name in names){
  //   print(name);
  // }

  // list.forEach((name) {
  //   print(name);
  // });

  Map<String, int> marks = {"Sachin": 80, "Rahul": 90};
  // for (var entry in marks.entries) {
  //   print("${entry.key} = ${entry.value}");
  // }

  for (int i = 0; i <= 100; i++) {
    if (i == 10) {
      break;
    }
    // print(i);
  }

  for (int i = 1; i <= 5; i++) {
    if (i == 3) {
      //3 ko skip krna ho to
      continue; //ye krne se jab condition right hone pe yhi se auper se loop start ho jaye value 3 print nhi hogi
    }

    print(i);
  }
}

void practice() {
  int even = 0;
  int odd = 0;
  int sum = 1;
  int divisible = 0;
  for (int i = 1; i <= 100; i++) {
    // print(i);
    sum += i;
    if (i % 2 == 0) {
      even++;
    } else if (i % 5 == 0) {
      divisible++;
    } else {
      odd++;
    }
  }
  print('even:$even,odd:$odd');
  print(sum);
  print(divisible);

  int biggestValue = 0;

  List<int> list = [10, 45, 2, 99, 32];
  int smallValue = list[0];
  for (int i = 0; i < list.length; i++) {
    int value = list[i];

    if (biggestValue <= value) {
      biggestValue = value;
    } else if (smallValue >= value) {
      smallValue = value;
    }
  }
  print(biggestValue);
  print(smallValue);

  int val10 = 0;

  List<int> list2 = [10, 20, 10, 30, 10, 40];
  for (int i = 0; i < list2.length; i++) {
    int value = list2[i];
    if (value == 10) {
      val10++;
    }
  }
  print(val10);

  for (int i = 1; i <= 5; i++) {
    for (int t = 1; t <= i; t++) {
      stdout.write(i);
    }
    print(' ');
  }
  for (int i = 1; i <= 5; i++) {
    for (int t = i; t >= 1; t--) {
      stdout.write(t);
    }
    print(' ');
  }
}

//Positional Parameters
void function(String name, int age, weight) {
  print(name);
  print(age);
  print(weight);
}

//Optional Positional Parameter
void function2(String name, int age, [double? weight]) {
  print(name);
  print(age);
  print(weight);
}

//Named Parameters
void function3({
  required String name,
  required int age,
  required double weight,
}) {
  print(name);
  print(age);
  print(weight);
}

//Default Value
void function4({String name = 'Jagat', int? age}) {
  print(name);
  print(age);
}

//Arrow Function
int square(int a, int b) => a * b;

//CallBack function

void sayHello() {
  print("Hello Sachin");
}

void executeFunction(Function callback) {
  print("Pehle ye kaam hua");

  callback(); // callback function ko call kiya
}

void collection() {
  // List<String> names = ["Sachin", "Rahul"];
  //
  // names.add("Amit");
  // names.addAll(['koyal,rani,raja']);
  // names[0]='Sachu';
  // names.insert(0, 'Raju');

  //
  //   print(names);
  //
  //   List<int> numbers=[10,44,30,5,50];
  //   numbers.removeWhere((number)=>number>30);
  // print(numbers);
  //   numbers.retainWhere((number)=>number>30);
  //   numbers.sort((a,b)=>b.compareTo(a));
  //   print(numbers);
  //   final result = numbers.reversed.toList();
  // print(result);

  Set<int> a = {1, 2, 3, 4};
  Set<int> b = {3, 4, 5, 6};

  // Set<int> output=a.intersection(b);
  // Set<int> output=a.union(b);
  Set<int> output = a.difference(b);
  print(output);
  List<int> numbers = [10, 15, 20, 25, 30];

  // List result=numbers.where((number)=>number % 2==0).toList();
  //isme hm jo chahe condition lga skte h ki kon kon si value cahiye list me se
  // final result=numbers.reduce((a,b)=>a+b);
  //Reduces a collection to a single value by iteratively combining elements of the collection using the provided function
  // final total = numbers.fold(
  //   0,
  //       (sum, number) => sum + number,
  // );
  final result = numbers.firstWhere(
    (number) => number > 20,
    orElse: () =>
        -1, //error handle ke liye agr list me kuch bhi n mile to return kr de
  );
  // final result=numbers.any((number)=>number>100);
  // final result2=numbers.every((number)=>number>0);
  print(result);

  // List<String> names = [
  //   "sachin",
  //   "rahul",
  //   "amit",
  // ];

  // final result2=names.map((name)=>name.toUpperCase());
  // //Har item ko transform karke new value banana.
  // print(result2);
}

void test() {
  List<Map<String, dynamic>> products = [
    {"name": "iPhone", "price": 80000, "stock": true},
    {"name": "Samsung", "price": 60000, "stock": false},
    {"name": "Pixel", "price": 70000, "stock": true},
  ];

  List result = products.where((product) => product['stock'] == true).toList();
  print(result);
  List result2 = products.map((product) => product['name']).toList();
  print(result2);
  final result3 = products.any((product) => product['stock'] == true);
  print(result3);
  final result4 = products.every((product) => product['stock'] == true);
  print(result4);
  final result5 = products.firstWhere((product) => product['stock'] == true);
  print(result5);
  final result6 = products.fold(
    0,
    (total, product) => total + product['price'] as int,
  );
  print(result6);
  products.sort((a, b) => b['price'].compareTo(a['price']));
  print(products);

  List<String> names = [
    "flutter",
    "dart",
    "flutter",
    "firebase",
    "dart",
    "api",
  ];

  // 1. Duplicate remove
  names = names.toSet().toList();

  // 2. Alphabetically sort
  names.sort();

  // 3. Sab uppercase
  final v = names.map((name) => name.toUpperCase());

  // 4. Check flutter exists
  final d = names.any((name) => name.contains('flutter'));

  // 5. dart remove
  names.removeWhere((name) => name == 'dart');

  print(names);

  List<Map<String, dynamic>> users = [
    {"name": "Sachin", "age": 20, "active": true},
    {"name": "Rahul", "age": 25, "active": false},
    {"name": "Amit", "age": 30, "active": true},
  ];

  //A.
  // Sirf active users nikalo.
  final active = users.where((user) => user['active'] == true).toList();
  print('active user $active');

  //B.
  // Sirf names nikalo.
  final onlyName = users.map((user) => user['name']).toList();
  print('only name $onlyName');

  //C.
  //
  // Kya koi user age 25 se greater hai?
  final age = users.where((user) => user['age'] > 25).toList();
  print('age user $age');

  //D.
  //
  // Kya sab users active hain?
  final isActive = users.every((user) => user['active'] == true);
  print('active user $isActive');

  //E
//Pehla active user nikalo

  final firstActive = users.firstWhere(
        (user) => user['active'] == true,
  );

  print(firstActive);

  //F.
  //
  // Users ki total age nikalo.

  final totalAge = users.fold(0, (sum, user) => sum + user['age'] as int);
  print("age total $totalAge");

  //G.
  //
  // Age ke according ascending sort karo.

 users.sort((a, b) => a['age'].compareTo(b['age']));
  print(users);
}
