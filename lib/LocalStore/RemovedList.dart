import 'dart:typed_data';

import 'package:hive/hive.dart';

part 'RemovedList.g.dart';

@HiveType(typeId: 1)
class RemovedList extends HiveObject {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? email;
  @HiveField(2)
  String? phone;
  @HiveField(3)
  String? password;
  @HiveField(4)
  Uint8List? profilePic;

  RemovedList(
      {required this.name,
      required this.email,
      required this.phone,
      required this.password,
      required this.profilePic});
}
