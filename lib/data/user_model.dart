class UserModel{
  String? id;
  String? name;
  String? email;
  String? phone;
  String? photourl;

  UserModel(this.id,this.name,this.email,this.phone,this.photourl);


  Map<String,dynamic> toJson(){
    return{
      "Full Name": name,
      "Email": email,
      "phone":phone,
      "uid":id,
      "photo":photourl
    };
  }

  Map<String,dynamic> toJson2(){
    return{
      "Full Name": name,
      "Email": email,
      "phone":phone,
      "uid":id,
      "photo":photourl
    };
  }
}