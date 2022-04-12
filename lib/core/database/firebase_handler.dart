import 'package:chat_app_demo/core/provider/groups_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../provider/users_provider.dart';
import '../utils/consts.dart';

class FirebaseHandler {
  static final FirebaseHandler _singleton = FirebaseHandler._internal();
  factory FirebaseHandler() => _singleton;
  FirebaseHandler._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Future<void> createUser(
      UserCredential authResult, Map<dynamic, dynamic> userData) async {
    await _firestore.collection(kUsers).doc(authResult.user?.uid).set({
      'username': userData['username'],
      'email': userData['email'],
    });
  }

  Future<void> createGroup(GroupModel groupModel) async {
    await _firestore
        .collection(kGroups)
        .doc(groupModel.id)
        .set(groupModel.toMap());
  }

  //Fetching  user data
  Future<UserModel?> getUser() async {
    final user = _firebaseAuth.currentUser;
    final userData = await _firestore.collection(kUsers).doc(user?.uid).get();

    if (userData.data() != null) {
      return UserModel.fromMap(userData.data()!, userData.id);
    } else {
      return null;
    }
  }

  //Fetch  group
  Future<UserModel?> getGroup(String groupId) async {
    final userData = await _firestore.collection(kGroups).doc(groupId).get();

    if (userData.data() != null) {
      return UserModel.fromMap(userData.data()!, userData.id);
    } else {
      return null;
    }
  }
}
