class UserModel {
  String? email;
  String? userId;
  String? userName;
  String? phone;
  String? imageUrl;
  String? location;
  String? date;
  List<String>? savedProduct;
  UserModel({
     required this.userId,
     required this.imageUrl,
     required this.userName,
     required this.email,
     required this.phone,
     required this.location,
     required this.date,
     required this.savedProduct,
});
  UserModel.fromJson(Map<dynamic, dynamic> json) {
    userId = json['id'];
    userName = json['user_name'];
    imageUrl = json['image'];
    date = json['date'];
    phone = json['phone'];
    email = json['email'];
    location = json['location'];
    savedProduct = json['saved'];
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = userId;
    data['image'] = imageUrl;
    data['user_name'] = userName;
    data['phone'] = phone;
    data['email'] = email;
    data['date'] = date;
    data['location'] = location;
    data['saved'] = savedProduct;
    return data;
  }

}