import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/item.dart';
import '../services/auth_service.dart';
import '../services/crud_service.dart';
import '../widgets/item_card.dart';
import '../widgets/item_form_dialog.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key, required this.user});

  final User user;

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CrudService _crudService = CrudService();

  Future<void> _showItemForm({Item? item}) async {
    final draft = await showDialog<ItemDraft>(
      context: context,
      builder: (context) => ItemFormDialog(item: item),
    );
    if (draft == null || !mounted) return;

    try {
      if (item == null) {
        await _crudService.addItem(draft);
      } else {
        await _crudService.updateItem(item.id, draft);
      }
    } catch (error) {
      if (mounted) {
        _showMessage('Could not save item: $error');
      }
    }
  }

  Future<void> _deleteItem(Item item) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete item?'),
        content: Text('Delete "${item.name}" from the inventory?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
    if (!mounted || shouldDelete != true) return;

    try {
      await _crudService.deleteItem(item.id);
    } catch (error) {
      if (mounted) {
        _showMessage('Could not delete item: $error');
      }
    }
  }

  Future<void> _signOut() async {
    try {
      await AuthService.instance.signOut();
    } catch (error) {
      if (mounted) {
        _showMessage('Could not sign out: $error');
      }
    }
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Firebase Inventory'),
        actions: [
          IconButton(
            onPressed: _signOut,
            tooltip: 'Sign out ${widget.user.displayName ?? ''}',
            icon: const Icon(Icons.logout),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: StreamBuilder<List<Item>>(
        stream: _crudService.streamItems(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('Could not load inventory: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final items = snapshot.data ?? [];
          if (items.isEmpty) {
            return const Center(
              child: Text('No items yet. Tap + to add your first item.'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.only(top: 8, bottom: 88),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return ItemCard(
                item: item,
                onEdit: () => _showItemForm(item: item),
                onDelete: () => _deleteItem(item),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showItemForm,
        tooltip: 'Add item',
        child: const Icon(Icons.add),
      ),
    );
  }
}
