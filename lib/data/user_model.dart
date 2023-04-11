class UserModel{
  String? id;
  String name;
  String email;
  String phone;
  String password;

  UserModel(this.id,this.name,this.email,this.phone,this.password);


  toJson(){
    return{
      "Full Name": name,
      "Email": email,
      "phone":phone,
      "password":password
    };
  }
}