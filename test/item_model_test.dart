import 'package:flutter_test/flutter_test.dart';

import 'package:firebase_cloudinary/models/item.dart';

void main() {
  test('item maps use the Firestore schema and round-trip correctly', () {
    const draft = ItemDraft(
      name: 'cake',
      quantity: 6,
      imageUrl: 'https://res.cloudinary.com/bsa2xrur/image/upload/cake.jpg',
    );

    final map = draft.toMap();
    final item = Item.fromMap('cake-id', map);

    expect(map.keys, containsAll(['name', 'quantity', 'image_url']));
    expect(item.id, 'cake-id');
    expect(item.name, draft.name);
    expect(item.quantity, draft.quantity);
    expect(item.imageUrl, draft.imageUrl);
  });
}
