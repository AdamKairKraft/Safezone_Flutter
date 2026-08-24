/// Mirrors safezone-web's `RoleType` (src/types/api.ts) and the backend's
/// com.safezone.identity RoleType enum.
enum RoleType {
  sheOfficer('SHE_OFFICER', 'SHE Officer'),
  siteSupervisor('SITE_SUPERVISOR', 'Site Supervisor'),
  generalWorker('GENERAL_WORKER', 'General Worker'),
  contractor('CONTRACTOR', 'Contractor'),
  management('MANAGEMENT', 'Management');

  const RoleType(this.wireValue, this.label);

  final String wireValue;
  final String label;

  static RoleType fromWire(String value) =>
      RoleType.values.firstWhere((r) => r.wireValue == value, orElse: () => RoleType.generalWorker);
}
