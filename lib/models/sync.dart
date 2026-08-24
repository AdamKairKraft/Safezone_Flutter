/// Mirrors the backend's `/api/sync/push` per-mutation result.
enum SyncMutationStatus {
  applied('APPLIED'),
  conflict('CONFLICT');

  const SyncMutationStatus(this.wireValue);

  final String wireValue;

  static SyncMutationStatus fromWire(String value) =>
      SyncMutationStatus.values.firstWhere((s) => s.wireValue == value, orElse: () => SyncMutationStatus.conflict);
}

class SyncMutationResult {
  const SyncMutationResult({
    required this.entityType,
    required this.entityId,
    required this.status,
    required this.currentVersion,
    required this.currentPayload,
    this.conflictId,
  });

  final String entityType;
  final String entityId;
  final SyncMutationStatus status;
  final int currentVersion;
  final Map<String, dynamic> currentPayload;
  final String? conflictId;

  factory SyncMutationResult.fromJson(Map<String, dynamic> json) => SyncMutationResult(
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        status: SyncMutationStatus.fromWire(json['status'] as String),
        currentVersion: json['currentVersion'] as int,
        currentPayload: Map<String, dynamic>.from(json['currentPayload'] as Map),
        conflictId: json['conflictId'] as String?,
      );
}

/// One row of a GET /api/sync/pull entity list (e.g. under the "report" key).
class SyncPullRecord {
  const SyncPullRecord({
    required this.id,
    required this.version,
    required this.payload,
    required this.updatedAt,
  });

  final String id;
  final int version;
  final Map<String, dynamic> payload;
  final DateTime updatedAt;

  factory SyncPullRecord.fromJson(Map<String, dynamic> json) => SyncPullRecord(
        id: json['id'] as String,
        version: json['version'] as int,
        payload: Map<String, dynamic>.from(json['payload'] as Map),
        updatedAt: DateTime.parse(json['updatedAt'] as String),
      );
}

enum ConflictResolution {
  keptServer('KEPT_SERVER'),
  restoredMine('RESTORED_MINE'),
  merged('MERGED');

  const ConflictResolution(this.wireValue);

  final String wireValue;
}

enum SyncConflictStatus {
  pending('PENDING'),
  resolved('RESOLVED');

  const SyncConflictStatus(this.wireValue);

  final String wireValue;

  static SyncConflictStatus fromWire(String value) =>
      SyncConflictStatus.values.firstWhere((s) => s.wireValue == value, orElse: () => SyncConflictStatus.pending);
}

class SyncConflict {
  const SyncConflict({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.losingPayload,
    required this.winningPayload,
    required this.status,
  });

  final String id;
  final String entityType;
  final String entityId;
  final Map<String, dynamic> losingPayload;
  final Map<String, dynamic> winningPayload;
  final SyncConflictStatus status;

  factory SyncConflict.fromJson(Map<String, dynamic> json) => SyncConflict(
        id: json['id'] as String,
        entityType: json['entityType'] as String,
        entityId: json['entityId'] as String,
        losingPayload: Map<String, dynamic>.from(json['losingPayload'] as Map),
        winningPayload: Map<String, dynamic>.from(json['winningPayload'] as Map),
        status: SyncConflictStatus.fromWire(json['status'] as String),
      );
}
