import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/item.dart';

class CrudService {
  CrudService({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  CollectionReference<Map<String, dynamic>> get _items =>
      _firestore.collection('items');

  Stream<List<Item>> streamItems() {
    return _items.snapshots().map((snapshot) {
      final items = snapshot.docs
          .map((document) => Item.fromMap(document.id, document.data()))
          .toList();
      items.sort(
        (first, second) =>
            first.name.toLowerCase().compareTo(second.name.toLowerCase()),
      );
      return items;
    });
  }

  Future<void> addItem(ItemDraft item) async {
    await _items.add(item.toMap());
  }

  Future<void> updateItem(String id, ItemDraft item) async {
    await _items.doc(id).update(item.toMap());
  }

  Future<void> deleteItem(String id) async {
    await _items.doc(id).delete();
  }
}
