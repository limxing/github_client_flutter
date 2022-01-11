// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) => User()
  ..login = json['login']
  ..avatar_url = json['avatar_url']
  ..type = json['type'] 
  ..name = json['name'] 
  ..company = json['company'] 
  ..blog = json['blog'] 
  ..location = json['location'] 
  ..email = json['email'] 
  ..hireable = json['hireable'] 
  ..bio = json['bio'] 
  ..public_repos = json['public_repos'] 
  ..followers = json['followers'] 
  ..following = json['following'] 
  ..created_at = json['created_at'] 
  ..updated_at = json['updated_at'] 
  ..total_private_repos = json['total_private_repos'] 
  ..owned_private_repos = json['owned_private_repos'] ;

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'login': instance.login,
      'avatar_url': instance.avatar_url,
      'type': instance.type,
      'name': instance.name,
      'company': instance.company,
      'blog': instance.blog,
      'location': instance.location,
      'email': instance.email,
      'hireable': instance.hireable,
      'bio': instance.bio,
      'public_repos': instance.public_repos,
      'followers': instance.followers,
      'following': instance.following,
      'created_at': instance.created_at,
      'updated_at': instance.updated_at,
      'total_private_repos': instance.total_private_repos,
      'owned_private_repos': instance.owned_private_repos,
    };
