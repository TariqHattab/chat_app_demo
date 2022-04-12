import 'package:firebase_auth/firebase_auth.dart';

import '../provider/users_provider.dart';

String getGroupId(User user, UserModel otherUser) {
  String groupId;
  if (user.uid.compareTo(otherUser.id) > 0) {
    groupId = user.uid + otherUser.id;
  } else {
    groupId = otherUser.id + user.uid;
  }
  return groupId;
}
