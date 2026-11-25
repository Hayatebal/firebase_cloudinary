class Item {
  const Item({
    required this.id,
    required this.name,
    required this.quantity,
    required this.imageUrl,
  });

  final String id;
  final String name;
  final int quantity;
  final String imageUrl;

  factory Item.fromMap(String id, Map<String, dynamic> data) {
    final name = data['name'];
    final quantity = data['quantity'];
    final imageUrl = data['image_url'];

    if (name is! String || quantity is! int || imageUrl is! String) {
      throw const FormatException('Item data has an invalid shape.');
    }

    return Item(id: id, name: name, quantity: quantity, imageUrl: imageUrl);
  }
}

class ItemDraft {
  const ItemDraft({
    required this.name,
    required this.quantity,
    required this.imageUrl,
  });

  final String name;
  final int quantity;
  final String imageUrl;

  Map<String, dynamic> toMap() {
    return {'name': name, 'quantity': quantity, 'image_url': imageUrl};
  }
}
