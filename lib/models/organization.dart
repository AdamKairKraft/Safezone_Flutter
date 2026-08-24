class Organization {
  const Organization({required this.id, required this.name, required this.version});

  final String id;
  final String name;
  final int version;

  factory Organization.fromJson(Map<String, dynamic> json) => Organization(
        id: json['id'] as String,
        name: json['name'] as String,
        version: json['version'] as int,
      );
}

class Site {
  const Site({required this.id, required this.organizationId, required this.name, required this.version});

  final String id;
  final String organizationId;
  final String name;
  final int version;

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        id: json['id'] as String,
        organizationId: json['organizationId'] as String,
        name: json['name'] as String,
        version: json['version'] as int,
      );
}
