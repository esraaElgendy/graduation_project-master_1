import 'package:equatable/equatable.dart';

/// User model representing student data
class UserModel extends Equatable {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? studentId;
  final String? major;
  final String? year;
  final double? gpa;
  final int? completedCreditHours;
  final int? remainingCreditHours;
  final int? totalCreditHours;

  const UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.studentId,
    this.major,
    this.year,
    this.gpa,
    this.completedCreditHours,
    this.remainingCreditHours,
    this.totalCreditHours,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? json['fullName']?.toString() ?? json['userName']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? json['phoneNumber']?.toString(),
      studentId: json['studentId']?.toString() ?? json['studentCode']?.toString(),
      major: json['major']?.toString() ?? json['department']?.toString(),
      year: json['year']?.toString() ?? json['level']?.toString(),
      gpa: _toDouble(json['gpa'] ?? json['GPA']),
      completedCreditHours: _toInt(json['completedCreditHours'] ?? json['completedHours']),
      remainingCreditHours: _toInt(json['remainingCreditHours'] ?? json['remainingHours']),
      totalCreditHours: _toInt(json['totalCreditHours'] ?? json['totalHours']),
    );
  }

  static int? _toInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is double) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  static double? _toDouble(dynamic value) {
    if (value == null) return null;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value);
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'studentId': studentId,
      'major': major,
      'year': year,
      'gpa': gpa,
      'completedCreditHours': completedCreditHours,
      'remainingCreditHours': remainingCreditHours,
      'totalCreditHours': totalCreditHours,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? studentId,
    String? major,
    String? year,
    double? gpa,
    int? completedCreditHours,
    int? remainingCreditHours,
    int? totalCreditHours,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      studentId: studentId ?? this.studentId,
      major: major ?? this.major,
      year: year ?? this.year,
      gpa: gpa ?? this.gpa,
      completedCreditHours: completedCreditHours ?? this.completedCreditHours,
      remainingCreditHours: remainingCreditHours ?? this.remainingCreditHours,
      totalCreditHours: totalCreditHours ?? this.totalCreditHours,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        email,
        phone,
        studentId,
        major,
        year,
        gpa,
        completedCreditHours,
        remainingCreditHours,
        totalCreditHours,
      ];
}
