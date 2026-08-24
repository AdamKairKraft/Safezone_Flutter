import 'package:flutter/material.dart';

import '../models/industry_module.dart';
import '../theme/app_theme.dart';

/// Renders one form field from a report type's formSchema - mirrors safezone-web's
/// DynamicField.tsx. This is what has to work fully offline once report types are
/// cached (FLUTTER_BUILD_PROMPT.md).
class DynamicFieldInput extends StatelessWidget {
  const DynamicFieldInput({super.key, required this.field, required this.value, required this.onChanged});

  final FormFieldSchema field;
  final dynamic value;
  final ValueChanged<dynamic> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text.rich(
          TextSpan(
            children: [
              TextSpan(
                text: field.label.toUpperCase(),
                style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: Color(0xFF374151)),
              ),
              if (field.required)
                const TextSpan(text: ' *', style: TextStyle(color: AppColors.red, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        const SizedBox(height: 6),
        _buildInput(),
      ],
    );
  }

  Widget _buildInput() {
    switch (field.type) {
      case FormFieldType.textarea:
        return TextFormField(
          initialValue: (value as String?) ?? '',
          maxLines: 4,
          onChanged: onChanged,
        );
      case FormFieldType.select:
        return DropdownButtonFormField<String>(
          initialValue: (value as String?)?.isEmpty ?? true ? null : value as String?,
          hint: const Text('Select…', style: TextStyle(fontSize: 13)),
          items: (field.options ?? const [])
              .map((option) => DropdownMenuItem(value: option, child: Text(option, style: const TextStyle(fontSize: 13))))
              .toList(),
          onChanged: onChanged,
        );
      case FormFieldType.number:
        return TextFormField(
          initialValue: value == null ? '' : '$value',
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          onChanged: (text) => onChanged(text.isEmpty ? null : num.tryParse(text)),
        );
      case FormFieldType.datetime:
        return _DateTimeField(value: value as String?, onChanged: onChanged);
      case FormFieldType.text:
        return TextFormField(
          initialValue: (value as String?) ?? '',
          onChanged: onChanged,
        );
    }
  }
}

class _DateTimeField extends StatelessWidget {
  const _DateTimeField({required this.value, required this.onChanged});

  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) {
    final parsed = value == null || value!.isEmpty ? null : DateTime.tryParse(value!);
    final display = parsed == null
        ? ''
        : '${parsed.year.toString().padLeft(4, '0')}-${parsed.month.toString().padLeft(2, '0')}-${parsed.day.toString().padLeft(2, '0')} '
            '${parsed.hour.toString().padLeft(2, '0')}:${parsed.minute.toString().padLeft(2, '0')}';

    return InkWell(
      onTap: () async {
        final now = DateTime.now();
        final date = await showDatePicker(
          context: context,
          initialDate: parsed ?? now,
          firstDate: DateTime(now.year - 2),
          lastDate: DateTime(now.year + 2),
        );
        if (date == null || !context.mounted) return;
        final time = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.fromDateTime(parsed ?? now),
        );
        if (time == null) return;
        final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);
        onChanged(combined.toIso8601String());
      },
      child: InputDecorator(
        decoration: const InputDecoration(suffixIcon: Icon(Icons.calendar_today, size: 16)),
        child: Text(display.isEmpty ? 'Select date & time…' : display, style: const TextStyle(fontSize: 13)),
      ),
    );
  }
}
