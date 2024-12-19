class Park {
  final int id;
  final String name;
  final String description;
  final double latitude;
  final double longitude;
  final double distance;

  Park({
    required this.id,
    required this.name,
    required this.description,
    required this.latitude,
    required this.longitude,
    required this.distance,
  });

  factory Park.fromJson(Map<String, dynamic> json) {
    return Park(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      latitude: double.parse(json['latitude']),
      longitude: double.parse(json['longitude']),
      distance: json['distance'].toDouble(),
    );
  }
}
