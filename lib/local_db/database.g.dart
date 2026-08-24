// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $ReportsCacheTable extends ReportsCache
    with TableInfo<$ReportsCacheTable, ReportsCacheData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ReportsCacheTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _organizationIdMeta = const VerificationMeta(
    'organizationId',
  );
  @override
  late final GeneratedColumn<String> organizationId = GeneratedColumn<String>(
    'organization_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _siteIdMeta = const VerificationMeta('siteId');
  @override
  late final GeneratedColumn<String> siteId = GeneratedColumn<String>(
    'site_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _industryModuleCodeMeta =
      const VerificationMeta('industryModuleCode');
  @override
  late final GeneratedColumn<String> industryModuleCode =
      GeneratedColumn<String>(
        'industry_module_code',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _reportTypeCodeMeta = const VerificationMeta(
    'reportTypeCode',
  );
  @override
  late final GeneratedColumn<String> reportTypeCode = GeneratedColumn<String>(
    'report_type_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dataJsonMeta = const VerificationMeta(
    'dataJson',
  );
  @override
  late final GeneratedColumn<String> dataJson = GeneratedColumn<String>(
    'data_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _submittedByMeta = const VerificationMeta(
    'submittedBy',
  );
  @override
  late final GeneratedColumn<String> submittedBy = GeneratedColumn<String>(
    'submitted_by',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _clientCreatedAtMeta = const VerificationMeta(
    'clientCreatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> clientCreatedAt =
      GeneratedColumn<DateTime>(
        'client_created_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _serverReceivedAtMeta = const VerificationMeta(
    'serverReceivedAt',
  );
  @override
  late final GeneratedColumn<DateTime> serverReceivedAt =
      GeneratedColumn<DateTime>(
        'server_received_at',
        aliasedName,
        false,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _versionMeta = const VerificationMeta(
    'version',
  );
  @override
  late final GeneratedColumn<int> version = GeneratedColumn<int>(
    'version',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dirtyMeta = const VerificationMeta('dirty');
  @override
  late final GeneratedColumn<bool> dirty = GeneratedColumn<bool>(
    'dirty',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("dirty" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    organizationId,
    siteId,
    industryModuleCode,
    reportTypeCode,
    status,
    dataJson,
    submittedBy,
    clientCreatedAt,
    serverReceivedAt,
    version,
    dirty,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'reports_cache';
  @override
  VerificationContext validateIntegrity(
    Insertable<ReportsCacheData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('organization_id')) {
      context.handle(
        _organizationIdMeta,
        organizationId.isAcceptableOrUnknown(
          data['organization_id']!,
          _organizationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_organizationIdMeta);
    }
    if (data.containsKey('site_id')) {
      context.handle(
        _siteIdMeta,
        siteId.isAcceptableOrUnknown(data['site_id']!, _siteIdMeta),
      );
    } else if (isInserting) {
      context.missing(_siteIdMeta);
    }
    if (data.containsKey('industry_module_code')) {
      context.handle(
        _industryModuleCodeMeta,
        industryModuleCode.isAcceptableOrUnknown(
          data['industry_module_code']!,
          _industryModuleCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_industryModuleCodeMeta);
    }
    if (data.containsKey('report_type_code')) {
      context.handle(
        _reportTypeCodeMeta,
        reportTypeCode.isAcceptableOrUnknown(
          data['report_type_code']!,
          _reportTypeCodeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_reportTypeCodeMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    } else if (isInserting) {
      context.missing(_statusMeta);
    }
    if (data.containsKey('data_json')) {
      context.handle(
        _dataJsonMeta,
        dataJson.isAcceptableOrUnknown(data['data_json']!, _dataJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_dataJsonMeta);
    }
    if (data.containsKey('submitted_by')) {
      context.handle(
        _submittedByMeta,
        submittedBy.isAcceptableOrUnknown(
          data['submitted_by']!,
          _submittedByMeta,
        ),
      );
    }
    if (data.containsKey('client_created_at')) {
      context.handle(
        _clientCreatedAtMeta,
        clientCreatedAt.isAcceptableOrUnknown(
          data['client_created_at']!,
          _clientCreatedAtMeta,
        ),
      );
    }
    if (data.containsKey('server_received_at')) {
      context.handle(
        _serverReceivedAtMeta,
        serverReceivedAt.isAcceptableOrUnknown(
          data['server_received_at']!,
          _serverReceivedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_serverReceivedAtMeta);
    }
    if (data.containsKey('version')) {
      context.handle(
        _versionMeta,
        version.isAcceptableOrUnknown(data['version']!, _versionMeta),
      );
    } else if (isInserting) {
      context.missing(_versionMeta);
    }
    if (data.containsKey('dirty')) {
      context.handle(
        _dirtyMeta,
        dirty.isAcceptableOrUnknown(data['dirty']!, _dirtyMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ReportsCacheData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ReportsCacheData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      organizationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}organization_id'],
      )!,
      siteId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}site_id'],
      )!,
      industryModuleCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}industry_module_code'],
      )!,
      reportTypeCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}report_type_code'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      dataJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}data_json'],
      )!,
      submittedBy: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}submitted_by'],
      ),
      clientCreatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}client_created_at'],
      ),
      serverReceivedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}server_received_at'],
      )!,
      version: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}version'],
      )!,
      dirty: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}dirty'],
      )!,
    );
  }

  @override
  $ReportsCacheTable createAlias(String alias) {
    return $ReportsCacheTable(attachedDatabase, alias);
  }
}

class ReportsCacheData extends DataClass
    implements Insertable<ReportsCacheData> {
  final String id;
  final String organizationId;
  final String siteId;
  final String industryModuleCode;
  final String reportTypeCode;
  final String status;
  final String dataJson;
  final String? submittedBy;
  final DateTime? clientCreatedAt;
  final DateTime serverReceivedAt;
  final int version;
  final bool dirty;
  const ReportsCacheData({
    required this.id,
    required this.organizationId,
    required this.siteId,
    required this.industryModuleCode,
    required this.reportTypeCode,
    required this.status,
    required this.dataJson,
    this.submittedBy,
    this.clientCreatedAt,
    required this.serverReceivedAt,
    required this.version,
    required this.dirty,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['organization_id'] = Variable<String>(organizationId);
    map['site_id'] = Variable<String>(siteId);
    map['industry_module_code'] = Variable<String>(industryModuleCode);
    map['report_type_code'] = Variable<String>(reportTypeCode);
    map['status'] = Variable<String>(status);
    map['data_json'] = Variable<String>(dataJson);
    if (!nullToAbsent || submittedBy != null) {
      map['submitted_by'] = Variable<String>(submittedBy);
    }
    if (!nullToAbsent || clientCreatedAt != null) {
      map['client_created_at'] = Variable<DateTime>(clientCreatedAt);
    }
    map['server_received_at'] = Variable<DateTime>(serverReceivedAt);
    map['version'] = Variable<int>(version);
    map['dirty'] = Variable<bool>(dirty);
    return map;
  }

  ReportsCacheCompanion toCompanion(bool nullToAbsent) {
    return ReportsCacheCompanion(
      id: Value(id),
      organizationId: Value(organizationId),
      siteId: Value(siteId),
      industryModuleCode: Value(industryModuleCode),
      reportTypeCode: Value(reportTypeCode),
      status: Value(status),
      dataJson: Value(dataJson),
      submittedBy: submittedBy == null && nullToAbsent
          ? const Value.absent()
          : Value(submittedBy),
      clientCreatedAt: clientCreatedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(clientCreatedAt),
      serverReceivedAt: Value(serverReceivedAt),
      version: Value(version),
      dirty: Value(dirty),
    );
  }

  factory ReportsCacheData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ReportsCacheData(
      id: serializer.fromJson<String>(json['id']),
      organizationId: serializer.fromJson<String>(json['organizationId']),
      siteId: serializer.fromJson<String>(json['siteId']),
      industryModuleCode: serializer.fromJson<String>(
        json['industryModuleCode'],
      ),
      reportTypeCode: serializer.fromJson<String>(json['reportTypeCode']),
      status: serializer.fromJson<String>(json['status']),
      dataJson: serializer.fromJson<String>(json['dataJson']),
      submittedBy: serializer.fromJson<String?>(json['submittedBy']),
      clientCreatedAt: serializer.fromJson<DateTime?>(json['clientCreatedAt']),
      serverReceivedAt: serializer.fromJson<DateTime>(json['serverReceivedAt']),
      version: serializer.fromJson<int>(json['version']),
      dirty: serializer.fromJson<bool>(json['dirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'organizationId': serializer.toJson<String>(organizationId),
      'siteId': serializer.toJson<String>(siteId),
      'industryModuleCode': serializer.toJson<String>(industryModuleCode),
      'reportTypeCode': serializer.toJson<String>(reportTypeCode),
      'status': serializer.toJson<String>(status),
      'dataJson': serializer.toJson<String>(dataJson),
      'submittedBy': serializer.toJson<String?>(submittedBy),
      'clientCreatedAt': serializer.toJson<DateTime?>(clientCreatedAt),
      'serverReceivedAt': serializer.toJson<DateTime>(serverReceivedAt),
      'version': serializer.toJson<int>(version),
      'dirty': serializer.toJson<bool>(dirty),
    };
  }

  ReportsCacheData copyWith({
    String? id,
    String? organizationId,
    String? siteId,
    String? industryModuleCode,
    String? reportTypeCode,
    String? status,
    String? dataJson,
    Value<String?> submittedBy = const Value.absent(),
    Value<DateTime?> clientCreatedAt = const Value.absent(),
    DateTime? serverReceivedAt,
    int? version,
    bool? dirty,
  }) => ReportsCacheData(
    id: id ?? this.id,
    organizationId: organizationId ?? this.organizationId,
    siteId: siteId ?? this.siteId,
    industryModuleCode: industryModuleCode ?? this.industryModuleCode,
    reportTypeCode: reportTypeCode ?? this.reportTypeCode,
    status: status ?? this.status,
    dataJson: dataJson ?? this.dataJson,
    submittedBy: submittedBy.present ? submittedBy.value : this.submittedBy,
    clientCreatedAt: clientCreatedAt.present
        ? clientCreatedAt.value
        : this.clientCreatedAt,
    serverReceivedAt: serverReceivedAt ?? this.serverReceivedAt,
    version: version ?? this.version,
    dirty: dirty ?? this.dirty,
  );
  ReportsCacheData copyWithCompanion(ReportsCacheCompanion data) {
    return ReportsCacheData(
      id: data.id.present ? data.id.value : this.id,
      organizationId: data.organizationId.present
          ? data.organizationId.value
          : this.organizationId,
      siteId: data.siteId.present ? data.siteId.value : this.siteId,
      industryModuleCode: data.industryModuleCode.present
          ? data.industryModuleCode.value
          : this.industryModuleCode,
      reportTypeCode: data.reportTypeCode.present
          ? data.reportTypeCode.value
          : this.reportTypeCode,
      status: data.status.present ? data.status.value : this.status,
      dataJson: data.dataJson.present ? data.dataJson.value : this.dataJson,
      submittedBy: data.submittedBy.present
          ? data.submittedBy.value
          : this.submittedBy,
      clientCreatedAt: data.clientCreatedAt.present
          ? data.clientCreatedAt.value
          : this.clientCreatedAt,
      serverReceivedAt: data.serverReceivedAt.present
          ? data.serverReceivedAt.value
          : this.serverReceivedAt,
      version: data.version.present ? data.version.value : this.version,
      dirty: data.dirty.present ? data.dirty.value : this.dirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCacheData(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('siteId: $siteId, ')
          ..write('industryModuleCode: $industryModuleCode, ')
          ..write('reportTypeCode: $reportTypeCode, ')
          ..write('status: $status, ')
          ..write('dataJson: $dataJson, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('clientCreatedAt: $clientCreatedAt, ')
          ..write('serverReceivedAt: $serverReceivedAt, ')
          ..write('version: $version, ')
          ..write('dirty: $dirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    organizationId,
    siteId,
    industryModuleCode,
    reportTypeCode,
    status,
    dataJson,
    submittedBy,
    clientCreatedAt,
    serverReceivedAt,
    version,
    dirty,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ReportsCacheData &&
          other.id == this.id &&
          other.organizationId == this.organizationId &&
          other.siteId == this.siteId &&
          other.industryModuleCode == this.industryModuleCode &&
          other.reportTypeCode == this.reportTypeCode &&
          other.status == this.status &&
          other.dataJson == this.dataJson &&
          other.submittedBy == this.submittedBy &&
          other.clientCreatedAt == this.clientCreatedAt &&
          other.serverReceivedAt == this.serverReceivedAt &&
          other.version == this.version &&
          other.dirty == this.dirty);
}

class ReportsCacheCompanion extends UpdateCompanion<ReportsCacheData> {
  final Value<String> id;
  final Value<String> organizationId;
  final Value<String> siteId;
  final Value<String> industryModuleCode;
  final Value<String> reportTypeCode;
  final Value<String> status;
  final Value<String> dataJson;
  final Value<String?> submittedBy;
  final Value<DateTime?> clientCreatedAt;
  final Value<DateTime> serverReceivedAt;
  final Value<int> version;
  final Value<bool> dirty;
  final Value<int> rowid;
  const ReportsCacheCompanion({
    this.id = const Value.absent(),
    this.organizationId = const Value.absent(),
    this.siteId = const Value.absent(),
    this.industryModuleCode = const Value.absent(),
    this.reportTypeCode = const Value.absent(),
    this.status = const Value.absent(),
    this.dataJson = const Value.absent(),
    this.submittedBy = const Value.absent(),
    this.clientCreatedAt = const Value.absent(),
    this.serverReceivedAt = const Value.absent(),
    this.version = const Value.absent(),
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ReportsCacheCompanion.insert({
    required String id,
    required String organizationId,
    required String siteId,
    required String industryModuleCode,
    required String reportTypeCode,
    required String status,
    required String dataJson,
    this.submittedBy = const Value.absent(),
    this.clientCreatedAt = const Value.absent(),
    required DateTime serverReceivedAt,
    required int version,
    this.dirty = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       organizationId = Value(organizationId),
       siteId = Value(siteId),
       industryModuleCode = Value(industryModuleCode),
       reportTypeCode = Value(reportTypeCode),
       status = Value(status),
       dataJson = Value(dataJson),
       serverReceivedAt = Value(serverReceivedAt),
       version = Value(version);
  static Insertable<ReportsCacheData> custom({
    Expression<String>? id,
    Expression<String>? organizationId,
    Expression<String>? siteId,
    Expression<String>? industryModuleCode,
    Expression<String>? reportTypeCode,
    Expression<String>? status,
    Expression<String>? dataJson,
    Expression<String>? submittedBy,
    Expression<DateTime>? clientCreatedAt,
    Expression<DateTime>? serverReceivedAt,
    Expression<int>? version,
    Expression<bool>? dirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (organizationId != null) 'organization_id': organizationId,
      if (siteId != null) 'site_id': siteId,
      if (industryModuleCode != null)
        'industry_module_code': industryModuleCode,
      if (reportTypeCode != null) 'report_type_code': reportTypeCode,
      if (status != null) 'status': status,
      if (dataJson != null) 'data_json': dataJson,
      if (submittedBy != null) 'submitted_by': submittedBy,
      if (clientCreatedAt != null) 'client_created_at': clientCreatedAt,
      if (serverReceivedAt != null) 'server_received_at': serverReceivedAt,
      if (version != null) 'version': version,
      if (dirty != null) 'dirty': dirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ReportsCacheCompanion copyWith({
    Value<String>? id,
    Value<String>? organizationId,
    Value<String>? siteId,
    Value<String>? industryModuleCode,
    Value<String>? reportTypeCode,
    Value<String>? status,
    Value<String>? dataJson,
    Value<String?>? submittedBy,
    Value<DateTime?>? clientCreatedAt,
    Value<DateTime>? serverReceivedAt,
    Value<int>? version,
    Value<bool>? dirty,
    Value<int>? rowid,
  }) {
    return ReportsCacheCompanion(
      id: id ?? this.id,
      organizationId: organizationId ?? this.organizationId,
      siteId: siteId ?? this.siteId,
      industryModuleCode: industryModuleCode ?? this.industryModuleCode,
      reportTypeCode: reportTypeCode ?? this.reportTypeCode,
      status: status ?? this.status,
      dataJson: dataJson ?? this.dataJson,
      submittedBy: submittedBy ?? this.submittedBy,
      clientCreatedAt: clientCreatedAt ?? this.clientCreatedAt,
      serverReceivedAt: serverReceivedAt ?? this.serverReceivedAt,
      version: version ?? this.version,
      dirty: dirty ?? this.dirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (organizationId.present) {
      map['organization_id'] = Variable<String>(organizationId.value);
    }
    if (siteId.present) {
      map['site_id'] = Variable<String>(siteId.value);
    }
    if (industryModuleCode.present) {
      map['industry_module_code'] = Variable<String>(industryModuleCode.value);
    }
    if (reportTypeCode.present) {
      map['report_type_code'] = Variable<String>(reportTypeCode.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (dataJson.present) {
      map['data_json'] = Variable<String>(dataJson.value);
    }
    if (submittedBy.present) {
      map['submitted_by'] = Variable<String>(submittedBy.value);
    }
    if (clientCreatedAt.present) {
      map['client_created_at'] = Variable<DateTime>(clientCreatedAt.value);
    }
    if (serverReceivedAt.present) {
      map['server_received_at'] = Variable<DateTime>(serverReceivedAt.value);
    }
    if (version.present) {
      map['version'] = Variable<int>(version.value);
    }
    if (dirty.present) {
      map['dirty'] = Variable<bool>(dirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ReportsCacheCompanion(')
          ..write('id: $id, ')
          ..write('organizationId: $organizationId, ')
          ..write('siteId: $siteId, ')
          ..write('industryModuleCode: $industryModuleCode, ')
          ..write('reportTypeCode: $reportTypeCode, ')
          ..write('status: $status, ')
          ..write('dataJson: $dataJson, ')
          ..write('submittedBy: $submittedBy, ')
          ..write('clientCreatedAt: $clientCreatedAt, ')
          ..write('serverReceivedAt: $serverReceivedAt, ')
          ..write('version: $version, ')
          ..write('dirty: $dirty, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MutationOutboxTable extends MutationOutbox
    with TableInfo<$MutationOutboxTable, MutationOutboxData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MutationOutboxTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityTypeMeta = const VerificationMeta(
    'entityType',
  );
  @override
  late final GeneratedColumn<String> entityType = GeneratedColumn<String>(
    'entity_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _entityIdMeta = const VerificationMeta(
    'entityId',
  );
  @override
  late final GeneratedColumn<String> entityId = GeneratedColumn<String>(
    'entity_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadJsonMeta = const VerificationMeta(
    'payloadJson',
  );
  @override
  late final GeneratedColumn<String> payloadJson = GeneratedColumn<String>(
    'payload_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _baseVersionMeta = const VerificationMeta(
    'baseVersion',
  );
  @override
  late final GeneratedColumn<int> baseVersion = GeneratedColumn<int>(
    'base_version',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    entityType,
    entityId,
    payloadJson,
    baseVersion,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'mutation_outbox';
  @override
  VerificationContext validateIntegrity(
    Insertable<MutationOutboxData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('entity_type')) {
      context.handle(
        _entityTypeMeta,
        entityType.isAcceptableOrUnknown(data['entity_type']!, _entityTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_entityTypeMeta);
    }
    if (data.containsKey('entity_id')) {
      context.handle(
        _entityIdMeta,
        entityId.isAcceptableOrUnknown(data['entity_id']!, _entityIdMeta),
      );
    } else if (isInserting) {
      context.missing(_entityIdMeta);
    }
    if (data.containsKey('payload_json')) {
      context.handle(
        _payloadJsonMeta,
        payloadJson.isAcceptableOrUnknown(
          data['payload_json']!,
          _payloadJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_payloadJsonMeta);
    }
    if (data.containsKey('base_version')) {
      context.handle(
        _baseVersionMeta,
        baseVersion.isAcceptableOrUnknown(
          data['base_version']!,
          _baseVersionMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MutationOutboxData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MutationOutboxData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      entityType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_type'],
      )!,
      entityId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}entity_id'],
      )!,
      payloadJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload_json'],
      )!,
      baseVersion: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}base_version'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $MutationOutboxTable createAlias(String alias) {
    return $MutationOutboxTable(attachedDatabase, alias);
  }
}

class MutationOutboxData extends DataClass
    implements Insertable<MutationOutboxData> {
  final String id;
  final String entityType;
  final String entityId;
  final String payloadJson;
  final int? baseVersion;
  final DateTime createdAt;
  const MutationOutboxData({
    required this.id,
    required this.entityType,
    required this.entityId,
    required this.payloadJson,
    this.baseVersion,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['entity_type'] = Variable<String>(entityType);
    map['entity_id'] = Variable<String>(entityId);
    map['payload_json'] = Variable<String>(payloadJson);
    if (!nullToAbsent || baseVersion != null) {
      map['base_version'] = Variable<int>(baseVersion);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  MutationOutboxCompanion toCompanion(bool nullToAbsent) {
    return MutationOutboxCompanion(
      id: Value(id),
      entityType: Value(entityType),
      entityId: Value(entityId),
      payloadJson: Value(payloadJson),
      baseVersion: baseVersion == null && nullToAbsent
          ? const Value.absent()
          : Value(baseVersion),
      createdAt: Value(createdAt),
    );
  }

  factory MutationOutboxData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MutationOutboxData(
      id: serializer.fromJson<String>(json['id']),
      entityType: serializer.fromJson<String>(json['entityType']),
      entityId: serializer.fromJson<String>(json['entityId']),
      payloadJson: serializer.fromJson<String>(json['payloadJson']),
      baseVersion: serializer.fromJson<int?>(json['baseVersion']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'entityType': serializer.toJson<String>(entityType),
      'entityId': serializer.toJson<String>(entityId),
      'payloadJson': serializer.toJson<String>(payloadJson),
      'baseVersion': serializer.toJson<int?>(baseVersion),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  MutationOutboxData copyWith({
    String? id,
    String? entityType,
    String? entityId,
    String? payloadJson,
    Value<int?> baseVersion = const Value.absent(),
    DateTime? createdAt,
  }) => MutationOutboxData(
    id: id ?? this.id,
    entityType: entityType ?? this.entityType,
    entityId: entityId ?? this.entityId,
    payloadJson: payloadJson ?? this.payloadJson,
    baseVersion: baseVersion.present ? baseVersion.value : this.baseVersion,
    createdAt: createdAt ?? this.createdAt,
  );
  MutationOutboxData copyWithCompanion(MutationOutboxCompanion data) {
    return MutationOutboxData(
      id: data.id.present ? data.id.value : this.id,
      entityType: data.entityType.present
          ? data.entityType.value
          : this.entityType,
      entityId: data.entityId.present ? data.entityId.value : this.entityId,
      payloadJson: data.payloadJson.present
          ? data.payloadJson.value
          : this.payloadJson,
      baseVersion: data.baseVersion.present
          ? data.baseVersion.value
          : this.baseVersion,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MutationOutboxData(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    entityType,
    entityId,
    payloadJson,
    baseVersion,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MutationOutboxData &&
          other.id == this.id &&
          other.entityType == this.entityType &&
          other.entityId == this.entityId &&
          other.payloadJson == this.payloadJson &&
          other.baseVersion == this.baseVersion &&
          other.createdAt == this.createdAt);
}

class MutationOutboxCompanion extends UpdateCompanion<MutationOutboxData> {
  final Value<String> id;
  final Value<String> entityType;
  final Value<String> entityId;
  final Value<String> payloadJson;
  final Value<int?> baseVersion;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const MutationOutboxCompanion({
    this.id = const Value.absent(),
    this.entityType = const Value.absent(),
    this.entityId = const Value.absent(),
    this.payloadJson = const Value.absent(),
    this.baseVersion = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MutationOutboxCompanion.insert({
    required String id,
    required String entityType,
    required String entityId,
    required String payloadJson,
    this.baseVersion = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       entityType = Value(entityType),
       entityId = Value(entityId),
       payloadJson = Value(payloadJson),
       createdAt = Value(createdAt);
  static Insertable<MutationOutboxData> custom({
    Expression<String>? id,
    Expression<String>? entityType,
    Expression<String>? entityId,
    Expression<String>? payloadJson,
    Expression<int>? baseVersion,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (entityType != null) 'entity_type': entityType,
      if (entityId != null) 'entity_id': entityId,
      if (payloadJson != null) 'payload_json': payloadJson,
      if (baseVersion != null) 'base_version': baseVersion,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MutationOutboxCompanion copyWith({
    Value<String>? id,
    Value<String>? entityType,
    Value<String>? entityId,
    Value<String>? payloadJson,
    Value<int?>? baseVersion,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return MutationOutboxCompanion(
      id: id ?? this.id,
      entityType: entityType ?? this.entityType,
      entityId: entityId ?? this.entityId,
      payloadJson: payloadJson ?? this.payloadJson,
      baseVersion: baseVersion ?? this.baseVersion,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (entityType.present) {
      map['entity_type'] = Variable<String>(entityType.value);
    }
    if (entityId.present) {
      map['entity_id'] = Variable<String>(entityId.value);
    }
    if (payloadJson.present) {
      map['payload_json'] = Variable<String>(payloadJson.value);
    }
    if (baseVersion.present) {
      map['base_version'] = Variable<int>(baseVersion.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MutationOutboxCompanion(')
          ..write('id: $id, ')
          ..write('entityType: $entityType, ')
          ..write('entityId: $entityId, ')
          ..write('payloadJson: $payloadJson, ')
          ..write('baseVersion: $baseVersion, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CacheEntriesTable extends CacheEntries
    with TableInfo<$CacheEntriesTable, CacheEntry> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CacheEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueJsonMeta = const VerificationMeta(
    'valueJson',
  );
  @override
  late final GeneratedColumn<String> valueJson = GeneratedColumn<String>(
    'value_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, valueJson, updatedAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cache_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<CacheEntry> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value_json')) {
      context.handle(
        _valueJsonMeta,
        valueJson.isAcceptableOrUnknown(data['value_json']!, _valueJsonMeta),
      );
    } else if (isInserting) {
      context.missing(_valueJsonMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  CacheEntry map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CacheEntry(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      valueJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value_json'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CacheEntriesTable createAlias(String alias) {
    return $CacheEntriesTable(attachedDatabase, alias);
  }
}

class CacheEntry extends DataClass implements Insertable<CacheEntry> {
  final String key;
  final String valueJson;
  final DateTime updatedAt;
  const CacheEntry({
    required this.key,
    required this.valueJson,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value_json'] = Variable<String>(valueJson);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CacheEntriesCompanion toCompanion(bool nullToAbsent) {
    return CacheEntriesCompanion(
      key: Value(key),
      valueJson: Value(valueJson),
      updatedAt: Value(updatedAt),
    );
  }

  factory CacheEntry.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CacheEntry(
      key: serializer.fromJson<String>(json['key']),
      valueJson: serializer.fromJson<String>(json['valueJson']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'valueJson': serializer.toJson<String>(valueJson),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CacheEntry copyWith({String? key, String? valueJson, DateTime? updatedAt}) =>
      CacheEntry(
        key: key ?? this.key,
        valueJson: valueJson ?? this.valueJson,
        updatedAt: updatedAt ?? this.updatedAt,
      );
  CacheEntry copyWithCompanion(CacheEntriesCompanion data) {
    return CacheEntry(
      key: data.key.present ? data.key.value : this.key,
      valueJson: data.valueJson.present ? data.valueJson.value : this.valueJson,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntry(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, valueJson, updatedAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CacheEntry &&
          other.key == this.key &&
          other.valueJson == this.valueJson &&
          other.updatedAt == this.updatedAt);
}

class CacheEntriesCompanion extends UpdateCompanion<CacheEntry> {
  final Value<String> key;
  final Value<String> valueJson;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CacheEntriesCompanion({
    this.key = const Value.absent(),
    this.valueJson = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CacheEntriesCompanion.insert({
    required String key,
    required String valueJson,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       valueJson = Value(valueJson),
       updatedAt = Value(updatedAt);
  static Insertable<CacheEntry> custom({
    Expression<String>? key,
    Expression<String>? valueJson,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (valueJson != null) 'value_json': valueJson,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CacheEntriesCompanion copyWith({
    Value<String>? key,
    Value<String>? valueJson,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CacheEntriesCompanion(
      key: key ?? this.key,
      valueJson: valueJson ?? this.valueJson,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (valueJson.present) {
      map['value_json'] = Variable<String>(valueJson.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CacheEntriesCompanion(')
          ..write('key: $key, ')
          ..write('valueJson: $valueJson, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ReportsCacheTable reportsCache = $ReportsCacheTable(this);
  late final $MutationOutboxTable mutationOutbox = $MutationOutboxTable(this);
  late final $CacheEntriesTable cacheEntries = $CacheEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    reportsCache,
    mutationOutbox,
    cacheEntries,
  ];
}

typedef $$ReportsCacheTableCreateCompanionBuilder =
    ReportsCacheCompanion Function({
      required String id,
      required String organizationId,
      required String siteId,
      required String industryModuleCode,
      required String reportTypeCode,
      required String status,
      required String dataJson,
      Value<String?> submittedBy,
      Value<DateTime?> clientCreatedAt,
      required DateTime serverReceivedAt,
      required int version,
      Value<bool> dirty,
      Value<int> rowid,
    });
typedef $$ReportsCacheTableUpdateCompanionBuilder =
    ReportsCacheCompanion Function({
      Value<String> id,
      Value<String> organizationId,
      Value<String> siteId,
      Value<String> industryModuleCode,
      Value<String> reportTypeCode,
      Value<String> status,
      Value<String> dataJson,
      Value<String?> submittedBy,
      Value<DateTime?> clientCreatedAt,
      Value<DateTime> serverReceivedAt,
      Value<int> version,
      Value<bool> dirty,
      Value<int> rowid,
    });

class $$ReportsCacheTableFilterComposer
    extends Composer<_$AppDatabase, $ReportsCacheTable> {
  $$ReportsCacheTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get industryModuleCode => $composableBuilder(
    column: $table.industryModuleCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reportTypeCode => $composableBuilder(
    column: $table.reportTypeCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get submittedBy => $composableBuilder(
    column: $table.submittedBy,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get serverReceivedAt => $composableBuilder(
    column: $table.serverReceivedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnFilters(column),
  );
}

class $$ReportsCacheTableOrderingComposer
    extends Composer<_$AppDatabase, $ReportsCacheTable> {
  $$ReportsCacheTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get siteId => $composableBuilder(
    column: $table.siteId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get industryModuleCode => $composableBuilder(
    column: $table.industryModuleCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reportTypeCode => $composableBuilder(
    column: $table.reportTypeCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dataJson => $composableBuilder(
    column: $table.dataJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get submittedBy => $composableBuilder(
    column: $table.submittedBy,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get serverReceivedAt => $composableBuilder(
    column: $table.serverReceivedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get version => $composableBuilder(
    column: $table.version,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get dirty => $composableBuilder(
    column: $table.dirty,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ReportsCacheTableAnnotationComposer
    extends Composer<_$AppDatabase, $ReportsCacheTable> {
  $$ReportsCacheTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get organizationId => $composableBuilder(
    column: $table.organizationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get siteId =>
      $composableBuilder(column: $table.siteId, builder: (column) => column);

  GeneratedColumn<String> get industryModuleCode => $composableBuilder(
    column: $table.industryModuleCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reportTypeCode => $composableBuilder(
    column: $table.reportTypeCode,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<String> get dataJson =>
      $composableBuilder(column: $table.dataJson, builder: (column) => column);

  GeneratedColumn<String> get submittedBy => $composableBuilder(
    column: $table.submittedBy,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get clientCreatedAt => $composableBuilder(
    column: $table.clientCreatedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get serverReceivedAt => $composableBuilder(
    column: $table.serverReceivedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get version =>
      $composableBuilder(column: $table.version, builder: (column) => column);

  GeneratedColumn<bool> get dirty =>
      $composableBuilder(column: $table.dirty, builder: (column) => column);
}

class $$ReportsCacheTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ReportsCacheTable,
          ReportsCacheData,
          $$ReportsCacheTableFilterComposer,
          $$ReportsCacheTableOrderingComposer,
          $$ReportsCacheTableAnnotationComposer,
          $$ReportsCacheTableCreateCompanionBuilder,
          $$ReportsCacheTableUpdateCompanionBuilder,
          (
            ReportsCacheData,
            BaseReferences<_$AppDatabase, $ReportsCacheTable, ReportsCacheData>,
          ),
          ReportsCacheData,
          PrefetchHooks Function()
        > {
  $$ReportsCacheTableTableManager(_$AppDatabase db, $ReportsCacheTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ReportsCacheTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ReportsCacheTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ReportsCacheTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> organizationId = const Value.absent(),
                Value<String> siteId = const Value.absent(),
                Value<String> industryModuleCode = const Value.absent(),
                Value<String> reportTypeCode = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<String> dataJson = const Value.absent(),
                Value<String?> submittedBy = const Value.absent(),
                Value<DateTime?> clientCreatedAt = const Value.absent(),
                Value<DateTime> serverReceivedAt = const Value.absent(),
                Value<int> version = const Value.absent(),
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCacheCompanion(
                id: id,
                organizationId: organizationId,
                siteId: siteId,
                industryModuleCode: industryModuleCode,
                reportTypeCode: reportTypeCode,
                status: status,
                dataJson: dataJson,
                submittedBy: submittedBy,
                clientCreatedAt: clientCreatedAt,
                serverReceivedAt: serverReceivedAt,
                version: version,
                dirty: dirty,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String organizationId,
                required String siteId,
                required String industryModuleCode,
                required String reportTypeCode,
                required String status,
                required String dataJson,
                Value<String?> submittedBy = const Value.absent(),
                Value<DateTime?> clientCreatedAt = const Value.absent(),
                required DateTime serverReceivedAt,
                required int version,
                Value<bool> dirty = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ReportsCacheCompanion.insert(
                id: id,
                organizationId: organizationId,
                siteId: siteId,
                industryModuleCode: industryModuleCode,
                reportTypeCode: reportTypeCode,
                status: status,
                dataJson: dataJson,
                submittedBy: submittedBy,
                clientCreatedAt: clientCreatedAt,
                serverReceivedAt: serverReceivedAt,
                version: version,
                dirty: dirty,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$ReportsCacheTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ReportsCacheTable,
      ReportsCacheData,
      $$ReportsCacheTableFilterComposer,
      $$ReportsCacheTableOrderingComposer,
      $$ReportsCacheTableAnnotationComposer,
      $$ReportsCacheTableCreateCompanionBuilder,
      $$ReportsCacheTableUpdateCompanionBuilder,
      (
        ReportsCacheData,
        BaseReferences<_$AppDatabase, $ReportsCacheTable, ReportsCacheData>,
      ),
      ReportsCacheData,
      PrefetchHooks Function()
    >;
typedef $$MutationOutboxTableCreateCompanionBuilder =
    MutationOutboxCompanion Function({
      required String id,
      required String entityType,
      required String entityId,
      required String payloadJson,
      Value<int?> baseVersion,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$MutationOutboxTableUpdateCompanionBuilder =
    MutationOutboxCompanion Function({
      Value<String> id,
      Value<String> entityType,
      Value<String> entityId,
      Value<String> payloadJson,
      Value<int?> baseVersion,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$MutationOutboxTableFilterComposer
    extends Composer<_$AppDatabase, $MutationOutboxTable> {
  $$MutationOutboxTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MutationOutboxTableOrderingComposer
    extends Composer<_$AppDatabase, $MutationOutboxTable> {
  $$MutationOutboxTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get entityId => $composableBuilder(
    column: $table.entityId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MutationOutboxTableAnnotationComposer
    extends Composer<_$AppDatabase, $MutationOutboxTable> {
  $$MutationOutboxTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get entityType => $composableBuilder(
    column: $table.entityType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get entityId =>
      $composableBuilder(column: $table.entityId, builder: (column) => column);

  GeneratedColumn<String> get payloadJson => $composableBuilder(
    column: $table.payloadJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get baseVersion => $composableBuilder(
    column: $table.baseVersion,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$MutationOutboxTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MutationOutboxTable,
          MutationOutboxData,
          $$MutationOutboxTableFilterComposer,
          $$MutationOutboxTableOrderingComposer,
          $$MutationOutboxTableAnnotationComposer,
          $$MutationOutboxTableCreateCompanionBuilder,
          $$MutationOutboxTableUpdateCompanionBuilder,
          (
            MutationOutboxData,
            BaseReferences<
              _$AppDatabase,
              $MutationOutboxTable,
              MutationOutboxData
            >,
          ),
          MutationOutboxData,
          PrefetchHooks Function()
        > {
  $$MutationOutboxTableTableManager(
    _$AppDatabase db,
    $MutationOutboxTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MutationOutboxTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MutationOutboxTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MutationOutboxTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> entityType = const Value.absent(),
                Value<String> entityId = const Value.absent(),
                Value<String> payloadJson = const Value.absent(),
                Value<int?> baseVersion = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => MutationOutboxCompanion(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                baseVersion: baseVersion,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String entityType,
                required String entityId,
                required String payloadJson,
                Value<int?> baseVersion = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => MutationOutboxCompanion.insert(
                id: id,
                entityType: entityType,
                entityId: entityId,
                payloadJson: payloadJson,
                baseVersion: baseVersion,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MutationOutboxTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MutationOutboxTable,
      MutationOutboxData,
      $$MutationOutboxTableFilterComposer,
      $$MutationOutboxTableOrderingComposer,
      $$MutationOutboxTableAnnotationComposer,
      $$MutationOutboxTableCreateCompanionBuilder,
      $$MutationOutboxTableUpdateCompanionBuilder,
      (
        MutationOutboxData,
        BaseReferences<_$AppDatabase, $MutationOutboxTable, MutationOutboxData>,
      ),
      MutationOutboxData,
      PrefetchHooks Function()
    >;
typedef $$CacheEntriesTableCreateCompanionBuilder =
    CacheEntriesCompanion Function({
      required String key,
      required String valueJson,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CacheEntriesTableUpdateCompanionBuilder =
    CacheEntriesCompanion Function({
      Value<String> key,
      Value<String> valueJson,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$CacheEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$CacheEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get valueJson => $composableBuilder(
    column: $table.valueJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CacheEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CacheEntriesTable> {
  $$CacheEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get valueJson =>
      $composableBuilder(column: $table.valueJson, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$CacheEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CacheEntriesTable,
          CacheEntry,
          $$CacheEntriesTableFilterComposer,
          $$CacheEntriesTableOrderingComposer,
          $$CacheEntriesTableAnnotationComposer,
          $$CacheEntriesTableCreateCompanionBuilder,
          $$CacheEntriesTableUpdateCompanionBuilder,
          (
            CacheEntry,
            BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
          ),
          CacheEntry,
          PrefetchHooks Function()
        > {
  $$CacheEntriesTableTableManager(_$AppDatabase db, $CacheEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CacheEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CacheEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CacheEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> valueJson = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String key,
                required String valueJson,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CacheEntriesCompanion.insert(
                key: key,
                valueJson: valueJson,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$CacheEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CacheEntriesTable,
      CacheEntry,
      $$CacheEntriesTableFilterComposer,
      $$CacheEntriesTableOrderingComposer,
      $$CacheEntriesTableAnnotationComposer,
      $$CacheEntriesTableCreateCompanionBuilder,
      $$CacheEntriesTableUpdateCompanionBuilder,
      (
        CacheEntry,
        BaseReferences<_$AppDatabase, $CacheEntriesTable, CacheEntry>,
      ),
      CacheEntry,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ReportsCacheTableTableManager get reportsCache =>
      $$ReportsCacheTableTableManager(_db, _db.reportsCache);
  $$MutationOutboxTableTableManager get mutationOutbox =>
      $$MutationOutboxTableTableManager(_db, _db.mutationOutbox);
  $$CacheEntriesTableTableManager get cacheEntries =>
      $$CacheEntriesTableTableManager(_db, _db.cacheEntries);
}
