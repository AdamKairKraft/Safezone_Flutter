import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class LabeledProgressBar extends StatelessWidget {
  const LabeledProgressBar({super.key, required this.label, required this.percent});

  final String label;
  final int percent;

  Color get _color {
    if (percent >= 90) return AppColors.green;
    if (percent >= 75) return AppColors.blue;
    return AppColors.amber;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: const TextStyle(fontSize: 11.5)),
              Text('$percent%', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 4),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: percent / 100,
              minHeight: 6,
              backgroundColor: AppColors.greyBg,
              valueColor: AlwaysStoppedAnimation(_color),
            ),
          ),
        ],
      ),
    );
  }
}
