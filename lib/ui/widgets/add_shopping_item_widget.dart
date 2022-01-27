import 'package:flutter/material.dart';

class AddShoppingItemWidget extends StatelessWidget {
  final void Function(String name) addItem;
  final TextEditingController _textFieldController = TextEditingController();

  AddShoppingItemWidget({
    Key? key,
    required this.addItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _textFieldController,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                decoration: const InputDecoration(
                  hintText: 'Write purchase here',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            const SizedBox(width: 16),
            SizedBox(
              height: 50,
              width: 100,
              child: ElevatedButton(
                onPressed: () {
                  addItem(_textFieldController.text);
                  _textFieldController.text = '';
                },
                child: const Text(
                  'ADD',
                  style: TextStyle(
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
