import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

class StatCard extends StatelessWidget {
  const StatCard({super.key, required this.label, required this.value, this.sub, this.valueColor});

  final String label;
  final String value;
  final String? sub;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.sub, fontWeight: FontWeight.w600)),
          const SizedBox(height: 6),
          Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: valueColor ?? AppColors.text)),
          if (sub != null) ...[
            const SizedBox(height: 2),
            Text(sub!, style: const TextStyle(fontSize: 11, color: AppColors.sub)),
          ],
        ],
      ),
    );
  }
}

class Panel extends StatelessWidget {
  const Panel({super.key, required this.title, this.trailing, required this.child});

  final String title;
  final String? trailing;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
              if (trailing != null) Text(trailing!, style: const TextStyle(fontSize: 11, color: AppColors.sub)),
            ],
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class EmptyHint extends StatelessWidget {
  const EmptyHint(this.message, {super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(message, style: const TextStyle(fontSize: 12, color: AppColors.sub)),
    );
  }
}

/// The wireframe's recurring amber "heads up" note style (e.g. login demo credentials,
/// SHE files metadata-only disclosure, roles page's "no data yet" hints).
class NoteBanner extends StatelessWidget {
  const NoteBanner({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.warnBg, borderRadius: BorderRadius.circular(6)),
      child: DefaultTextStyle(
        style: const TextStyle(fontSize: 11.5, color: AppColors.warnText),
        child: child,
      ),
    );
  }
}
