import 'package:intl/intl.dart';

String humanize(String code) {
  return code
      .toLowerCase()
      .split('_')
      .map((word) => word.isEmpty ? word : word[0].toUpperCase() + word.substring(1))
      .join(' ');
}

String formatDate(DateTime? value) {
  if (value == null) return '—';
  return DateFormat.MMMd().format(value.toLocal());
}

String formatDateLong(DateTime? value) {
  if (value == null) return '—';
  return DateFormat.yMMMd().format(value.toLocal());
}

const _summaryFields = ['topic', 'description', 'controlPoint', 'findings', 'treatmentGiven', 'aircraftId'];

/// Best-effort human summary of a report's freeform `data` JSON for list/dashboard
/// display - mirrors safezone-web's src/lib/format.ts reportSummary exactly.
String reportSummary(String reportTypeCode, Map<String, dynamic> data) {
  for (final field in _summaryFields) {
    final value = data[field];
    if (value is String && value.trim().isNotEmpty) return value;
  }
  return humanize(reportTypeCode);
}

int? daysUntil(DateTime? date) {
  if (date == null) return null;
  return date.toLocal().difference(DateTime.now()).inDays;
}
