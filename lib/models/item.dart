class Item {
  final int id;
  final String name;
  final int price;
  final String location;
  final String image;

  Item({
    required this.id,
    required this.name,
    required this.price,
    required this.location,
    required this.image,
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      location: json['location'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'location': location,
      'image': image,
    };
  }
}
