class Subdistrict {
  final int id;
  final String code;
  final String name;
  final int districtId;
  final DateTime createdAt;
  final DateTime updatedAt;

  Subdistrict({
    required this.id,
    required this.code,
    required this.name,
    required this.districtId,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Subdistrict.fromJson(Map<String, dynamic> json) {
    return Subdistrict(
      id: json['id'],
      code: json['code'],
      name: json['name'],
      districtId: json['district_id'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
