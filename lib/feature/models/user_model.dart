import 'package:hive/hive.dart';
part 'user_model.g.dart';

@HiveType(typeId: 0)
class UserModel {
  @HiveField(0)
  final String email;

  @HiveField(1)
  final String password;

  @HiveField(2)
  final String? region;

  @HiveField(3)
  final String? district;

  UserModel({
    required this.email,
    required this.password,
    this.region,
    this.district,
  });
}
