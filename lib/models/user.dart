import 'dart:convert';

class User {
  final String id;
  final String first_name;
  final String last_name;
  final String email;
  final String gender;
  final String date_of_birth;
  final String phone_no;

  User(this.id, this.first_name, this.last_name, this.email, this.gender, this.date_of_birth, this.phone_no);

  User._({this.id, this.first_name, this.last_name, this.email, this.gender, this.date_of_birth, this.phone_no});

  factory User.fromJson(Map<String, dynamic> json) {
    return new User._(
      id: json['id'],
      first_name: json['first_name'],
      last_name: json['last_name'],
      email: json['email'],
      gender: json['gender'],
      date_of_birth: json['date_of_birth'],
      phone_no: json['phone_no'],
    );
  }
}
