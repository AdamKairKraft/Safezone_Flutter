enum ReportStatus {
  draft('DRAFT'),
  submitted('SUBMITTED'),
  underReview('UNDER_REVIEW'),
  closed('CLOSED');

  const ReportStatus(this.wireValue);

  final String wireValue;

  static ReportStatus fromWire(String value) =>
      ReportStatus.values.firstWhere((s) => s.wireValue == value, orElse: () => ReportStatus.draft);
}

class Report {
  const Report({
    required this.id,
    required this.organizationId,
    required this.siteId,
    required this.industryModuleCode,
    required this.reportTypeCode,
    required this.status,
    required this.data,
    required this.submittedBy,
    required this.clientCreatedAt,
    required this.serverReceivedAt,
    required this.version,
  });

  final String id;
  final String organizationId;
  final String siteId;
  final String industryModuleCode;
  final String reportTypeCode;
  final ReportStatus status;
  final Map<String, dynamic> data;
  final String? submittedBy;
  final DateTime? clientCreatedAt;
  final DateTime serverReceivedAt;
  final int version;

  factory Report.fromJson(Map<String, dynamic> json) => Report(
        id: json['id'] as String,
        organizationId: json['organizationId'] as String,
        siteId: json['siteId'] as String,
        industryModuleCode: json['industryModuleCode'] as String,
        reportTypeCode: json['reportTypeCode'] as String,
        status: ReportStatus.fromWire(json['status'] as String),
        data: Map<String, dynamic>.from(json['data'] as Map),
        submittedBy: json['submittedBy'] as String?,
        clientCreatedAt:
            json['clientCreatedAt'] == null ? null : DateTime.parse(json['clientCreatedAt'] as String),
        serverReceivedAt: DateTime.parse(json['serverReceivedAt'] as String),
        version: json['version'] as int,
      );

  Report copyWith({
    ReportStatus? status,
    Map<String, dynamic>? data,
    int? version,
  }) =>
      Report(
        id: id,
        organizationId: organizationId,
        siteId: siteId,
        industryModuleCode: industryModuleCode,
        reportTypeCode: reportTypeCode,
        status: status ?? this.status,
        data: data ?? this.data,
        submittedBy: submittedBy,
        clientCreatedAt: clientCreatedAt,
        serverReceivedAt: serverReceivedAt,
        version: version ?? this.version,
      );
}

/// The payload shape the sync push/pull protocol and PUT /api/reports/{id} both use -
/// deliberately excludes `status`, matching the backend's UpsertReportRequest (submitting
/// is a separate, online-only action, never part of a draft upsert or sync mutation).
class ReportDraftPayload {
  const ReportDraftPayload({
    required this.organizationId,
    required this.siteId,
    required this.industryModuleCode,
    required this.reportTypeCode,
    required this.data,
    this.clientCreatedAt,
  });

  final String organizationId;
  final String siteId;
  final String industryModuleCode;
  final String reportTypeCode;
  final Map<String, dynamic> data;
  final DateTime? clientCreatedAt;

  Map<String, dynamic> toJson() => {
        'organizationId': organizationId,
        'siteId': siteId,
        'industryModuleCode': industryModuleCode,
        'reportTypeCode': reportTypeCode,
        'data': data,
        if (clientCreatedAt != null) 'clientCreatedAt': clientCreatedAt!.toUtc().toIso8601String(),
      };
}
