class User{
  String _name;

  String get name=>_name;

  User(this._name);

  set name(String name){
    if(name.isNotEmpty){
      _name=name;
    }else{
      print('your name is empty');
    }
    }
  }


void main(){

  User user=User('ajay');
user.name='ankit';
print(user.name);
}