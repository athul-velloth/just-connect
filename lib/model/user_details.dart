class UserDetails {
  final int id;
  final String createdAt;
  final String email;
  final String password;
  final String name;
  final int phoneNumber;
  final int flatNo;
  final String jobType;
  final String signUpType;
  final String? imageUrl;
  final String? uploadedAt;

  UserDetails({
    required this.id,
    required this.createdAt,
    required this.email,
    required this.password,
    required this.name,
    required this.phoneNumber,
    required this.flatNo,
    required this.jobType,
    required this.signUpType,
    this.imageUrl,
    this.uploadedAt,
  });

  // Factory method to create a User instance from JSON
  factory UserDetails.fromJson(Map<String, dynamic> json) {
    return UserDetails(
      id: json['id'] as int,
      createdAt: json['created_at'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      phoneNumber: json['phone_number'] as int,
      flatNo: json['flat_no'] as int,
      jobType: json['job_type'] as String,
      signUpType: json['sign_up_type'] as String,
      imageUrl: json['image_url'] as String?,
      uploadedAt: json['uploaded_at'] as String?,
    );
  }

  // Optional: Convert the User instance back to JSON (useful for inserts)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'created_at': createdAt,
      'email': email,
      'password': password,
      'name': name,
      'phone_number': phoneNumber,
      'flat_no': flatNo,
      //  'job_type': jobType,
      'sign_up_type': signUpType,
      'image_url': imageUrl,
      'uploaded_at': uploadedAt,
    };
  }
}
