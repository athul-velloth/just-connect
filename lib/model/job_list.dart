class JobList {
  final int id;
  final String createdAt;
  final String jobName;
  final String priceHr;
  final String location;
  final String time;

  JobList({
    required this.id,
    required this.createdAt,
    required this.jobName,
    required this.priceHr,
    required this.location,
    required this.time,
  });

  // Factory method to create a User instance from JSON
  factory JobList.fromJson(Map<String, dynamic> json) {
    return JobList(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      jobName: json['job_name'] as String,
      priceHr: json['price_hr'] as String,
      location: json['location'] as String,
      time: json['time'] as String,
    );
  }

  // Optional: Convert the User instance back to JSON (useful for inserts)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'job_name': jobName,
      'price_hr': priceHr,
      'location': location,
      'time': time,
    };
  }
}
