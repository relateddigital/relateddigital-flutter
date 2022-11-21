class RDInitRequestModel {
  String organizationId;
  String profileId;
  String dataSource;
  bool askLocationPermissionAtStart;

  RDInitRequestModel(
      {required this.organizationId,
      required this.profileId,
      required this.dataSource,
      this.askLocationPermissionAtStart = false});
}
