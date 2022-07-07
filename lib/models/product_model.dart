class Employer{
  String? id;
  List? images;
  String? title;
  String? category;
  String? price;
  String? description;
  String? sellerId;
  String? date;
  Employer(
      {
        this.id,
        this.images,
        this.title,
        this.category,
        this.price,
        this.description,
        this.sellerId,
        this.date,
      });

  Employer.fromJson(Map<String , dynamic>json){
    id = json['id'];
    title = json['title'];
    category  = json['category'];
    images = json['images'];
    date = json['date'];
    price =json['price'];
    sellerId = json['seller'];
    description = json['description'];
  }
  Map<dynamic, dynamic> toJson(){
    final Map<dynamic, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['images'] = images;
    data['title'] = title;
    data['category'] = category;
    data['price'] = price;
    data['seller'] = sellerId;
    data['date'] = date;
    data['description'] = description;
    return data;
  }

}