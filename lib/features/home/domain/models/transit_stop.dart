class TransitStop {
  final int id;
  final String name;
  final String? address;
  final double latitude;
  final double longitude;
  final DateTime createdAt;
  final DateTime updatedAt;
  final double distance;

  TransitStop({
    required this.id,
    required this.name,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.createdAt,
    required this.updatedAt,
    required this.distance,
  });

  factory TransitStop.fromJson(Map<String, dynamic> json) {
    return TransitStop(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      distance: json['distance'].toDouble(),
    );
  }
}
