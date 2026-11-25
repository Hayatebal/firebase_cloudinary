import 'package:flutter/material.dart';

import '../models/item.dart';

class ItemCard extends StatelessWidget {
  const ItemCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final Item item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: SizedBox(
            width: 48,
            height: 48,
            child: item.imageUrl.isEmpty
                ? const ColoredBox(
                    color: Color(0xFFE5E5E5),
                    child: Icon(Icons.inventory_2_outlined),
                  )
                : Image.network(
                    item.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const ColoredBox(
                          color: Color(0xFFE5E5E5),
                          child: Icon(Icons.broken_image_outlined),
                        ),
                  ),
          ),
        ),
        title: Text(
          item.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text('Quantity ${item.quantity}'),
        trailing: Wrap(
          spacing: 2,
          children: [
            IconButton(
              onPressed: onEdit,
              tooltip: 'Edit ${item.name}',
              color: const Color(0xFFFF9800),
              icon: const Icon(Icons.edit),
            ),
            IconButton(
              onPressed: onDelete,
              tooltip: 'Delete ${item.name}',
              color: const Color(0xFFE53935),
              icon: const Icon(Icons.delete),
            ),
          ],
        ),
      ),
    );
  }
}
