import 'package:flutter/material.dart';

import 'package:shoppinglist/models/shopping_item.dart';
import 'package:shoppinglist/services/firestore_service.dart';

class ShoppingItemWidget extends StatefulWidget {
  final ShoppingItem item;
  const ShoppingItemWidget({
    Key? key,
    required this.item,
  }) : super(key: key);

  @override
  State<ShoppingItemWidget> createState() => _ShoppingItemWidgetState();
}

class _ShoppingItemWidgetState extends State<ShoppingItemWidget> {
  late final ShoppingItem item;
  late bool isChecked;

  @override
  void initState() {
    super.initState();
    item = widget.item;
    isChecked = item.isPurchased;
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Checkbox(
        value: isChecked,
        onChanged: (value) async {
          setState(() {
            isChecked = value!;
          });
          await FirestoreService.updateShoppingItem(item.itemId, value!);
        },
      ),
      title: Text(item.name),
      trailing: IconButton(
        onPressed: () => FirestoreService.removeShoppingItem(item.itemId),
        icon: const Icon(Icons.delete),
      ),
    );
  }
}
