class ProductModel{
  String? title;
  int? id;
  dynamic price;
  String? description;
  String? category;
  String? image;
  Map<String, dynamic>? rating;

  ProductModel({this.title, this.id, this.price, this.description, this.category, this.image, this.rating});

  ProductModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    id = json['id'];
    price = json['price'];
    description = json['description'];
    image = json['image'];
    rating = json['rating'];
    category = json['category'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['title'] = title;
    data['id'] = id;
    data['price'] = price;
    data['description'] = description;
    data['image'] = image;
    data['rating'] = rating;
    data['category'] = category;
    return data;
  }
}