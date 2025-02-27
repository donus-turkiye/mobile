// lib/models/user_model.dart

class UserModel {
  final String id;
  final String name;
  final String email;
  final String profileImageUrl;
  double walletBalance;
  int totalRecycledItems;
  double totalEarnings;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.profileImageUrl = '',
    this.walletBalance = 0.0,
    this.totalRecycledItems = 0,
    this.totalEarnings = 0.0,
  });

  // Veritabanından (JSON) veri çekerken kullanılacak constructor
  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      profileImageUrl: map['profileImageUrl'] ?? '',
      walletBalance: map['walletBalance']?.toDouble() ?? 0.0,
      totalRecycledItems: map['totalRecycledItems']?.toInt() ?? 0,
      totalEarnings: map['totalEarnings']?.toDouble() ?? 0.0,
    );
  }

  // Veritabanına veri gönderirken kullanılacak metod
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'profileImageUrl': profileImageUrl,
      'walletBalance': walletBalance,
      'totalRecycledItems': totalRecycledItems,
      'totalEarnings': totalEarnings,
    };
  }
  
  // Kullanıcı bilgilerini güncelleyen kopya oluşturma metodu
  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImageUrl,
    double? walletBalance,
    int? totalRecycledItems,
    double? totalEarnings,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      walletBalance: walletBalance ?? this.walletBalance,
      totalRecycledItems: totalRecycledItems ?? this.totalRecycledItems,
      totalEarnings: totalEarnings ?? this.totalEarnings,
    );
  }
}