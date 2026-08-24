class IndustryModule {
  const IndustryModule({required this.id, required this.code, required this.name, this.description});

  final String id;
  final String code;
  final String name;
  final String? description;

  factory IndustryModule.fromJson(Map<String, dynamic> json) => IndustryModule(
        id: json['id'] as String,
        code: json['code'] as String,
        name: json['name'] as String,
        description: json['description'] as String?,
      );
}

enum FormFieldType {
  text,
  textarea,
  number,
  select,
  datetime;

  static FormFieldType fromWire(String value) =>
      FormFieldType.values.firstWhere((t) => t.name == value, orElse: () => FormFieldType.text);
}

class FormFieldSchema {
  const FormFieldSchema({
    required this.name,
    required this.label,
    required this.type,
    required this.required,
    this.options,
  });

  final String name;
  final String label;
  final FormFieldType type;
  final bool required;
  final List<String>? options;

  factory FormFieldSchema.fromJson(Map<String, dynamic> json) => FormFieldSchema(
        name: json['name'] as String,
        label: json['label'] as String,
        type: FormFieldType.fromWire(json['type'] as String),
        required: json['required'] as bool? ?? false,
        options: (json['options'] as List<dynamic>?)?.map((o) => o as String).toList(),
      );
}

class ReportTypeDefinition {
  const ReportTypeDefinition({
    required this.id,
    required this.code,
    required this.name,
    required this.fields,
  });

  final String id;
  final String code;
  final String name;
  final List<FormFieldSchema> fields;

  factory ReportTypeDefinition.fromJson(Map<String, dynamic> json) {
    final schema = json['formSchema'] as Map<String, dynamic>? ?? const {};
    final fieldsJson = schema['fields'] as List<dynamic>? ?? const [];
    return ReportTypeDefinition(
      id: json['id'] as String,
      code: json['code'] as String,
      name: json['name'] as String,
      fields: fieldsJson.map((f) => FormFieldSchema.fromJson(f as Map<String, dynamic>)).toList(),
    );
  }

  /// For local caching: round-trips through JSON so the drift cache can store it as text.
  Map<String, dynamic> toCacheJson() => {
        'id': id,
        'code': code,
        'name': name,
        'formSchema': {
          'fields': fields
              .map((f) => {
                    'name': f.name,
                    'label': f.label,
                    'type': f.type.name,
                    'required': f.required,
                    if (f.options != null) 'options': f.options,
                  })
              .toList(),
        },
      };
}

class RoleResponsibility {
  const RoleResponsibility({required this.id, required this.description});

  final String id;
  final String description;

  factory RoleResponsibility.fromJson(Map<String, dynamic> json) =>
      RoleResponsibility(id: json['id'] as String, description: json['description'] as String);
}

class RoleRequiredReport {
  const RoleRequiredReport({
    required this.id,
    required this.reportTypeCode,
    required this.reportTypeName,
    required this.frequencyLabel,
  });

  final String id;
  final String reportTypeCode;
  final String reportTypeName;
  final String frequencyLabel;

  factory RoleRequiredReport.fromJson(Map<String, dynamic> json) => RoleRequiredReport(
        id: json['id'] as String,
        reportTypeCode: json['reportTypeCode'] as String,
        reportTypeName: json['reportTypeName'] as String,
        frequencyLabel: json['frequencyLabel'] as String,
      );
}
