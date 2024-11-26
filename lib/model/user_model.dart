import 'dart:core';

class UserModel {
  final String userId;
  final String name;
  final String address;
  final String gender;

  UserModel({required this.userId,
    required this.name,
    required this.address,
    required this.gender});

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'address': address,
      'gender': gender
    };
  }

  factory UserModel.fromjson(Map<String, dynamic>json){
    return UserModel(userId: json['userId'],
        name: json['name'],
        address: json['address'],
        gender: json['gender']);
  }
}
