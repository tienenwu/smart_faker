import 'package:smart_faker/smart_faker.dart';

// Note: Code generation is not yet implemented
// part 'user_model.smart_faker.g.dart';

/// Example user model with SmartFaker annotations
@FakerSchema(timestamps: true)
class User {
  @FakerField(type: FakerFieldType.uuid)
  final String id;

  @FakerField(type: FakerFieldType.firstName)
  final String firstName;

  @FakerField(type: FakerFieldType.lastName)
  final String lastName;

  @FakerField(type: FakerFieldType.email)
  final String email;

  @FakerField(type: FakerFieldType.phone)
  final String? phoneNumber;

  @FakerField(type: FakerFieldType.integer, min: 18, max: 65)
  final int age;

  @FakerField(type: FakerFieldType.jobTitle)
  final String? jobTitle;

  @FakerField(type: FakerFieldType.paragraph)
  final String? bio;

  @FakerField(type: FakerFieldType.avatar)
  final String? avatarUrl;

  @FakerField(type: FakerFieldType.boolean)
  final bool isActive;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    this.phoneNumber,
    required this.age,
    this.jobTitle,
    this.bio,
    this.avatarUrl,
    required this.isActive,
    this.createdAt,
    this.updatedAt,
  });
}
