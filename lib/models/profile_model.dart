class ProfileModel {
  final int id;
  final String fullName;
  final String email;
  final String phone;
  final String? profilePhoto;
  final bool? isActive;
  final String? address;
   final String? role;      
  //final String? hospital; 
   final int? centerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  ProfileModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.profilePhoto,
    this.isActive,
    this.address,
    this.role,
    //this.hospital,
    this.centerId,
    this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as int? ?? 0,
      fullName: json['full_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      profilePhoto: json['profile_photo'] as String?,
      isActive: json['is_active'] == null
          ? null
          : (json['is_active'] is bool
              ? json['is_active']
              : json['is_active'] == 1),
      address: json['address'] as String?,
          role: json['role'] as String?,
    //  hospital: json['hospital'] as String?,
    centerId: json['center_id'] as int?,
      createdAt: json['created_at'] == null
          ? null
          : DateTime.tryParse(json['created_at'] as String),
      updatedAt: json['updated_at'] == null
          ? null
          : DateTime.tryParse(json['updated_at'] as String),
    );
  }

  ProfileModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? phone,
    String? profilePhoto,
    bool? isActive,
    String? address,
    String? role,
    String? hospital,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      profilePhoto: profilePhoto ?? this.profilePhoto,
      isActive: isActive ?? this.isActive,
      address: address ?? this.address,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        "id": id,
        "full_name": fullName,
        "email": email,
        "phone": phone,
        "profile_photo": profilePhoto,
        "is_active": isActive,
        "address": address,
          //  "role": role,
    //"hospital": hospital,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
