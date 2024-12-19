class LocationList {
  final int id;
  final String createdAt;
  final String locationName;

  LocationList({
    required this.id,
    required this.createdAt,
    required this.locationName,
  });

  // Factory method to create a User instance from JSON
  factory LocationList.fromJson(Map<String, dynamic> json) {
    return LocationList(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      locationName: json['location_name'] as String,
    );
  }

  // Optional: Convert the User instance back to JSON (useful for inserts)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'location_name': locationName,
    };
  }
}
