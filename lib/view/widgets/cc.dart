import 'package:flutter/material.dart';

class CategoryChip extends StatelessWidget {
  final String label;

  const CategoryChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: Chip(
        label: Text(
          label,
          style: const TextStyle(fontSize: 14),
        ),
        backgroundColor: Colors.blue.withOpacity(0.1),
        shape: const StadiumBorder(),
      ),
    );
  }
}
