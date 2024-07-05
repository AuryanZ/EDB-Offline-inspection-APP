class Inspections {
  final int? id;
  final String name;
  final String codeKey;
  final String code;
  final bool status;
  final DateTime inspectionDate;
  final DateTime lastModifedDate;
  final String file;
  final String data;

  Inspections({
    this.id,
    required this.name,
    required this.codeKey,
    required this.code,
    required this.status,
    required this.inspectionDate,
    required this.lastModifedDate,
    required this.file,
    required this.data,
  });

  factory Inspections.fromMap(Map<String, dynamic> json) => Inspections(
        id: json['id'],
        name: json['name'],
        codeKey: json['codeKey'],
        code: json['code'],
        status: json['status'] == 1 ? true : false,
        inspectionDate: DateTime.parse(json['inspectionDate']),
        lastModifedDate: DateTime.parse(json['lastModifedDate']),
        file: json['file'],
        data: json['data'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'codeKey': codeKey,
        'code': code,
        'status': status ? 1 : 0,
        'inspectionDate': inspectionDate.toString(),
        'lastModifedDate': lastModifedDate.toString(),
        'file': file,
        'data': data,
      };
}
