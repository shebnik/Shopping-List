import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shoppinglist/models/shopping_item.dart';
import 'package:shoppinglist/services/auth_service.dart';
import 'package:shoppinglist/services/firestore_service.dart';
import 'package:shoppinglist/ui/widgets/add_shopping_item_widget.dart';
import 'package:shoppinglist/ui/widgets/app_filter_chip.dart';
import 'package:shoppinglist/ui/widgets/app_icon.dart';
import 'package:shoppinglist/ui/widgets/loading.dart';
import 'package:shoppinglist/ui/widgets/shopping_item_widget.dart';

class HomePage extends StatefulWidget {
  final String title;

  static const routeName = '/home';

  const HomePage({Key? key, required this.title}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ValueNotifier<int> selectedChipIndex = ValueNotifier(0);

  void _chipSelected(int index) {
    selectedChipIndex.value = index;
  }

  void _addItem(String name) {
    FirestoreService.addShoppingItem(name);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const AppIcon(),
        title: Text(widget.title),
        actions: [
          PopupMenuButton(
            onSelected: (result) {
              AuthService.logout();
            },
            itemBuilder: (BuildContext context) => [
              const PopupMenuItem(
                value: 0,
                child: Text('Log out'),
              ),
            ],
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: sortingChips(),
            ),
            Expanded(child: itemsList()),
            AddShoppingItemWidget(
              addItem: _addItem,
            ),
          ],
        ),
      ),
    );
  }

  Widget sortingChips() {
    return ValueListenableBuilder<int>(
      valueListenable: selectedChipIndex,
      builder: (context, value, child) => Wrap(
        children: [
          AppFilterChip(
            index: 0,
            selectedIndex: value,
            label: 'All',
            onSelected: _chipSelected,
          ),
          AppFilterChip(
            index: 1,
            selectedIndex: value,
            label: 'Not purchased',
            onSelected: _chipSelected,
          ),
          AppFilterChip(
            index: 2,
            selectedIndex: value,
            label: 'Purchased',
            onSelected: _chipSelected,
          ),
        ],
      ),
    );
  }

  Widget itemsList() {
    return StreamBuilder<QuerySnapshot>(
      stream: FirestoreService.getShoppingItems(AuthService.getUserId()!),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return const Text('Something went wrong');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const LoadingIndicator();
        }

        final docs = snapshot.data!.docs;

        return ValueListenableBuilder<int>(
          valueListenable: selectedChipIndex,
          builder: (context, value, child) => ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final item = docs[index].data() as ShoppingItem;

              if (value == 1 && item.isPurchased) {
                return const SizedBox.shrink();
              }

              if (value == 2 && item.isPurchased == false) {
                return const SizedBox.shrink();
              }

              return ShoppingItemWidget(
                item: item,
                key: UniqueKey(),
              );
            },
          ),
        );
      },
    );
  }
}
