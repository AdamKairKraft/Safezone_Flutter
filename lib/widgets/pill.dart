import 'package:flutter/material.dart';

import '../utils/status_styles.dart';

class Pill extends StatelessWidget {
  const Pill({super.key, required this.label, required this.variant});

  final String label;
  final PillVariant variant;

  @override
  Widget build(BuildContext context) {
    final style = pillStyle(variant);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(color: style.background, borderRadius: BorderRadius.circular(999)),
      child: Text(
        label,
        style: TextStyle(color: style.foreground, fontSize: 11, fontWeight: FontWeight.w600),
      ),
    );
  }
}
