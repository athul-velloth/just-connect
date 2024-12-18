class JobDetailsModel {
  final int id;
  final String createdAt;
  final int ownerId;
  final String ownerName;
  final String? flatNo;
  final String date;
  final String jobType;
  final String jobStatus;
  final String? ownerProfileImage;
  final int? phoneNumber;
  final String? title;
  final String? description;
  JobDetailsModel({
    required this.id,
    required this.createdAt,
    required this.ownerId,
    required this.ownerName,
    this.flatNo,
    required this.date,
    required this.jobType,
    required this.jobStatus,
    this.ownerProfileImage,
    this.phoneNumber,
    this.title,
    this.description,
  });

  // Factory method to create a User instance from JSON
  factory JobDetailsModel.fromJson(Map<String, dynamic> json) {
    return JobDetailsModel(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      ownerId: json['owner_id'] as int,
      ownerName: json['owner_name'] as String,
      flatNo: json['flat_no'] as String?,
      date: json['date'] as String,
      jobType: json['job_type'] as String,
      jobStatus: json['job_status'] as String,
      ownerProfileImage: json['owner_profile_image'] as String?,
      phoneNumber: json['phone_number'] as int,
      title: json['title'] as String?,
      description: json['description'] as String?,
    );
  }

  // Optional: Convert the User instance back to JSON (useful for inserts)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'owner_id': ownerId,
      'owner_name': ownerName,
      'flat_no': flatNo,
      'date': date,
      'job_type': jobType,
      'job_status': jobStatus,
      'owner_profile_image': ownerProfileImage,
      'phone_number': phoneNumber,
      'title': title,
      'description': description
    };
  }
}
