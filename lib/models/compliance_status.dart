enum ComplianceFrequency {
  weekly('WEEKLY'),
  monthly('MONTHLY'),
  asNeeded('AS_NEEDED');

  const ComplianceFrequency(this.wireValue);

  final String wireValue;

  static ComplianceFrequency fromWire(String value) => ComplianceFrequency.values
      .firstWhere((f) => f.wireValue == value, orElse: () => ComplianceFrequency.asNeeded);
}

enum ComplianceState {
  ok('OK'),
  dueSoon('DUE_SOON'),
  overdue('OVERDUE');

  const ComplianceState(this.wireValue);

  final String wireValue;

  static ComplianceState fromWire(String value) =>
      ComplianceState.values.firstWhere((s) => s.wireValue == value, orElse: () => ComplianceState.ok);
}

class ComplianceStatus {
  const ComplianceStatus({
    required this.id,
    required this.categoryCode,
    required this.reportTypeCode,
    required this.frequency,
    required this.lastCompletedAt,
    required this.state,
  });

  final String id;
  final String categoryCode;
  final String reportTypeCode;
  final ComplianceFrequency frequency;
  final DateTime? lastCompletedAt;
  final ComplianceState state;

  factory ComplianceStatus.fromJson(Map<String, dynamic> json) => ComplianceStatus(
        id: json['id'] as String,
        categoryCode: json['categoryCode'] as String,
        reportTypeCode: json['reportTypeCode'] as String,
        frequency: ComplianceFrequency.fromWire(json['frequency'] as String),
        lastCompletedAt:
            json['lastCompletedAt'] == null ? null : DateTime.parse(json['lastCompletedAt'] as String),
        state: ComplianceState.fromWire(json['state'] as String),
      );
}
