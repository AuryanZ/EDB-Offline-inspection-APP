class PillarBoxModel {
  final String? localId;
  final String? streetNumber;
  final String? streetName;
  final String? town;
  final String? bondedTo;
  final double? gpsN;
  final double? gpsE;
  final String? feeder;
  final String? assetGroup;
  final String? pillarBoxType;
  final String? maintArea;

  PillarBoxModel({
    required this.localId,
    this.streetNumber,
    this.streetName,
    this.town,
    this.bondedTo,
    this.gpsN,
    this.gpsE,
    this.feeder,
    this.assetGroup,
    this.pillarBoxType,
    this.maintArea,
  });

  factory PillarBoxModel.fromMap(Map<String, dynamic> json) => PillarBoxModel(
        localId: json['local_id'],
        streetNumber: json['street_number'],
        streetName: json['street_name'],
        town: json['town'],
        bondedTo: json['bonded_to'],
        gpsN: json['gps_n'],
        gpsE: json['gps_e'],
        feeder: json['feeder'],
        assetGroup: json['asset_group'],
        pillarBoxType: json['box_type'],
        maintArea: json['maint_area'],
      );
}
