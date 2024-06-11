class Templates {
  final String formName;
  final int fromVersion;
  final String data;

  const Templates(
      {required this.formName, required this.fromVersion, required this.data});

  factory Templates.fromJson(Map<String, dynamic> formTemp) => Templates(
      formName: formTemp['formName'],
      fromVersion: formTemp['fromVersion'],
      data: formTemp['data']);

  Map<String, Object?> toJson() {
    return {
      'formName': formName,
      'fromVersion': fromVersion,
      'data': data,
    };
  }
}
