import 'package:hive/hive.dart';

part 'userinfo_model.g.dart';

@HiveType(typeId: 7)
class UserInfoModel extends HiveObject {
  @HiveField(0)
  String firstName;

  @HiveField(1)
  String lastName;

  @HiveField(2)
  String email;

  @HiveField(3)
  String password;

  UserInfoModel(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.password});
}
