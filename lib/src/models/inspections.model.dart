class Inspections {
  final int? id;
  final String name;
  final DateTime inspectionDate;
  final DateTime lastModifedDate;
  final String data;

  Inspections({
    this.id,
    required this.name,
    required this.inspectionDate,
    required this.lastModifedDate,
    required this.data,
  });

  factory Inspections.fromMap(Map<String, dynamic> json) => Inspections(
        id: json['id'],
        name: json['name'],
        inspectionDate: DateTime.parse(json['inspectionDate']),
        lastModifedDate: DateTime.parse(json['lastModifedDate']),
        data: json['data'],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'inspectionDate': inspectionDate.toIso8601String(),
        'lastModifedDate': lastModifedDate.toIso8601String(),
        'data': data,
      };
}
