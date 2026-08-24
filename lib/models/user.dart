import 'role_type.dart';

class AppUser {
  const AppUser({
    required this.id,
    required this.organizationId,
    required this.email,
    required this.fullName,
    required this.roles,
  });

  final String id;
  final String organizationId;
  final String email;
  final String fullName;
  final List<RoleType> roles;

  factory AppUser.fromJson(Map<String, dynamic> json) => AppUser(
        id: json['id'] as String,
        organizationId: json['organizationId'] as String,
        email: json['email'] as String,
        fullName: json['fullName'] as String,
        roles: (json['roles'] as List<dynamic>).map((r) => RoleType.fromWire(r as String)).toList(),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'organizationId': organizationId,
        'email': email,
        'fullName': fullName,
        'roles': roles.map((r) => r.wireValue).toList(),
      };
}

class AuthResponse {
  const AuthResponse({
    required this.accessToken,
    required this.refreshToken,
    required this.expiresIn,
    required this.user,
  });

  final String accessToken;
  final String refreshToken;
  final int expiresIn;
  final AppUser user;

  factory AuthResponse.fromJson(Map<String, dynamic> json) => AuthResponse(
        accessToken: json['accessToken'] as String,
        refreshToken: json['refreshToken'] as String,
        expiresIn: json['expiresIn'] as int,
        user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      );
}
