import 'package:hive/hive.dart';

part 'userinfo_model.g.dart';

@HiveType(typeId: 7)
class UserInfoModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String firstName;

  @HiveField(2)
  String lastName;

  @HiveField(3)
  String email;

  @HiveField(4)
  String password;

  UserInfoModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});
}
