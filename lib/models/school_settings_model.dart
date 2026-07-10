class SchoolSettingsModel {
  final int? id;
  final String organizationName;
  final String eiin;
  final String address;
  final String phone;
  final String email;
  final String website;
  final String principalName;
  final String principalDesignation;
  final String? logoPath;
  final String? principalPhotoPath;
  final String? principalSignaturePath;

  const SchoolSettingsModel({
    this.id,
    required this.organizationName,
    required this.eiin,
    required this.address,
    required this.phone,
    required this.email,
    required this.website,
    required this.principalName,
    required this.principalDesignation,
    this.logoPath,
    this.principalPhotoPath,
    this.principalSignaturePath,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'organization_name': organizationName,
      'eiin': eiin,
      'address': address,
      'phone': phone,
      'email': email,
      'website': website,
      'principal_name': principalName,
      'principal_designation': principalDesignation,
      'logo_path': logoPath,
      'principal_photo_path': principalPhotoPath,
      'principal_signature_path': principalSignaturePath,
    };
  }

  factory SchoolSettingsModel.fromMap(Map<String, dynamic> map) {
    return SchoolSettingsModel(
      id: map['id'] as int?,
      organizationName: map['organization_name'] as String? ?? '',
      eiin: map['eiin'] as String? ?? '',
      address: map['address'] as String? ?? '',
      phone: map['phone'] as String? ?? '',
      email: map['email'] as String? ?? '',
      website: map['website'] as String? ?? '',
      principalName: map['principal_name'] as String? ?? '',
      principalDesignation:
          map['principal_designation'] as String? ?? '',
      logoPath: map['logo_path'] as String?,
      principalPhotoPath:
          map['principal_photo_path'] as String?,
      principalSignaturePath:
          map['principal_signature_path'] as String?,
    );
  }

  SchoolSettingsModel copyWith({
    int? id,
    String? organizationName,
    String? eiin,
    String? address,
    String? phone,
    String? email,
    String? website,
    String? principalName,
    String? principalDesignation,
    String? logoPath,
    String? principalPhotoPath,
    String? principalSignaturePath,
  }) {
    return SchoolSettingsModel(
      id: id ?? this.id,
      organizationName: organizationName ?? this.organizationName,
      eiin: eiin ?? this.eiin,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      principalName: principalName ?? this.principalName,
      principalDesignation:
          principalDesignation ?? this.principalDesignation,
      logoPath: logoPath ?? this.logoPath,
      principalPhotoPath:
          principalPhotoPath ?? this.principalPhotoPath,
      principalSignaturePath:
          principalSignaturePath ?? this.principalSignaturePath,
    );
  }

  @override
  String toString() {
    return 'SchoolSettingsModel(id: $id, organizationName: $organizationName)';
  }
}