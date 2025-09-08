import 'gender.dart';

/// Represents a generated person with various attributes.
class Person {
  final String firstName;
  final String lastName;
  final String fullName;
  final int age;
  final Gender gender;
  final String jobTitle;
  final String email;
  final String phone;

  Person({
    required this.firstName,
    required this.lastName,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.jobTitle,
    required this.email,
    required this.phone,
  });
}
