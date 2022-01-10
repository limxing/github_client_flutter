import 'package:json_annotation/json_annotation.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  late String login;
  late String avatar_url;
  late String type;
  late String name;
  late String company;
  late String blog;
  late String location;
  late String email;
  late bool hireable;
  late String bio;
  late num public_repos;
  late num followers;
  late num following;
  late String created_at;
  late String updated_at;
  late num total_private_repos;
  late num owned_private_repos;
  
  factory User.fromJson(Map<String,dynamic> json) => _$UserFromJson(json);
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
