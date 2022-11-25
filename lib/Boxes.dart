import 'package:hive/hive.dart';

import 'LocalStore/AllUserDetails.dart';
import 'LocalStore/RemovedList.dart';

class Boxes {
  static Box<UserDetails> getAllUser() => Hive.box<UserDetails>('GetUser');
  static Box<RemovedList> getAllRemovedUser() =>
      Hive.box<RemovedList>('GetRemovedUser');
}
