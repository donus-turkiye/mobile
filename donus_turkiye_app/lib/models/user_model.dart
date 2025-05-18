// lib/models/user_model.dart

class UserModel {
  final int id;
  final String fullName;
  final String email;
  final String telNumber;
  final String address;
  final String coordinate;
  final int roleId;

  // Opsiyonel alanlar
  final String profileImageUrl;
  final double walletBalance;
  final int totalRecycledItems;
  final double totalEarnings;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.telNumber,
    required this.address,
    required this.coordinate,
    required this.roleId,
    this.profileImageUrl = '',
    this.walletBalance = 0.0,
    this.totalRecycledItems = 0,
    this.totalEarnings = 0.0,
  });
  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel.fromMap(json);
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? 0,
      fullName: map['full_name'] ?? '',
      email: map['email'] ?? '',
      telNumber: map['tel_number'] ?? '',
      address: map['address'] ?? '',
      coordinate: map['coordinate'] ?? '',
      roleId: map['role_id'] ?? 0,
      profileImageUrl: map['profileImageUrl'] ?? '',
      walletBalance: map['walletBalance']?.toDouble() ?? 0.0,
      totalRecycledItems: map['totalRecycledItems']?.toInt() ?? 0,
      totalEarnings: map['totalEarnings']?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'tel_number': telNumber,
      'address': address,
      'coordinate': coordinate,
      'role_id': roleId,
      'profileImageUrl': profileImageUrl,
      'walletBalance': walletBalance,
      'totalRecycledItems': totalRecycledItems,
      'totalEarnings': totalEarnings,
    };
  }

  UserModel copyWith({
    int? id,
    String? fullName,
    String? email,
    String? telNumber,
    String? address,
    String? coordinate,
    int? roleId,
    String? profileImageUrl,
    double? walletBalance,
    int? totalRecycledItems,
    double? totalEarnings,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      telNumber: telNumber ?? this.telNumber,
      address: address ?? this.address,
      coordinate: coordinate ?? this.coordinate,
      roleId: roleId ?? this.roleId,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      totalRecycledItems: totalRecycledItems ?? this.totalRecycledItems,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}
