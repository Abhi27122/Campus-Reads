class Selling_data{
  final String title;
  final String price;
  final DateTime dt;
  final String userid;
  final String photourl;

  Selling_data(this.title,this.price,this.dt,this.userid,this.photourl);

  Map<String,dynamic> toJson(){
    return{
      "Name": title,
      "Date": dt,
      "userId":userid,
      "image":photourl,
      "price":price
    };
  }

}


class Profile_data{
  String? name;
  String? email;
  String? phone;
  Profile_data(this.name,this.email,this.phone);
}