enum SheFileCategory {
  legalAppointment('LEGAL_APPOINTMENT', 'Legal Appointment'),
  policyProcedure('POLICY_PROCEDURE', 'Policies & Procedures'),
  trainingCertificate('TRAINING_CERTIFICATE', 'Training & Certificates'),
  equipmentCertificate('EQUIPMENT_CERTIFICATE', 'Equipment & Inspection Certs'),
  permitLicense('PERMIT_LICENSE', 'Permits & Licenses');

  const SheFileCategory(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static SheFileCategory fromWire(String value) => SheFileCategory.values
      .firstWhere((c) => c.wireValue == value, orElse: () => SheFileCategory.policyProcedure);
}

enum SheFileStatus {
  valid('VALID', 'Valid'),
  expiringSoon('EXPIRING_SOON', 'Expiring soon'),
  expired('EXPIRED', 'Expired');

  const SheFileStatus(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static SheFileStatus fromWire(String value) =>
      SheFileStatus.values.firstWhere((s) => s.wireValue == value, orElse: () => SheFileStatus.valid);
}

class SheFile {
  const SheFile({
    required this.id,
    required this.organizationId,
    required this.siteId,
    required this.category,
    required this.title,
    required this.ownerUserId,
    required this.expiryDate,
    required this.status,
  });

  final String id;
  final String organizationId;
  final String? siteId;
  final SheFileCategory category;
  final String title;
  final String? ownerUserId;
  final DateTime? expiryDate;
  final SheFileStatus status;

  factory SheFile.fromJson(Map<String, dynamic> json) => SheFile(
        id: json['id'] as String,
        organizationId: json['organizationId'] as String,
        siteId: json['siteId'] as String?,
        category: SheFileCategory.fromWire(json['category'] as String),
        title: json['title'] as String,
        ownerUserId: json['ownerUserId'] as String?,
        expiryDate: json['expiryDate'] == null ? null : DateTime.parse(json['expiryDate'] as String),
        status: SheFileStatus.fromWire(json['status'] as String),
      );
}
