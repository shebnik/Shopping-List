import 'package:flutter/material.dart';

class AppFilterChip extends StatelessWidget {
  final String label;
  final int index;
  final int selectedIndex;
  final void Function(int) onSelected;

  const AppFilterChip({
    Key? key,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(6),
      child: FilterChip(
        label: Text(label),
        selected: index == selectedIndex,
        onSelected: (bool value) {
          if (index == selectedIndex) return;
          onSelected(index);
        },
      ),
    );
  }
}
