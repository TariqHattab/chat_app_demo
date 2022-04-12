import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/consts.dart';

class UserModel {
  late String id;
  String? username;
  String? email;
  List<String>? groupIds;
  UserModel(this.username, this.email);

  UserModel.fromMap(Map<String, dynamic> user, this.id) {
    username = user['username'];
    email = user['email'];
    groupIds = user['groupIds'];
  }
}

class UsersProvider {
  List<UserModel> users = [];
  bool isLoading = false;
  UserModel? userInfo;
  final firebaseCurrentUser = FirebaseAuth.instance.currentUser;

  UsersProvider({
    this.isLoading = true,
    this.users = const [],
  });
  UsersProvider.fromMap(QuerySnapshot<Map<String, dynamic>> usersSnapShots) {
    isLoading = false;

    for (var doc in usersSnapShots.docs) {
      if (firebaseCurrentUser?.uid == doc.id) {
        userInfo = UserModel.fromMap(doc.data(), doc.id);
      } else {
        users.add(UserModel.fromMap(doc.data(), doc.id));
      }
    }
  }

  UserModel? getOtherUserInfo(String id) {
    try {
      return users.firstWhere((user) => user.id == id);
    } catch (e) {
      return null;
    }
  }
}

//Fetching  users
Stream<UsersProvider> getUsers() {
  print('---------------------started to get users');
  return FirebaseFirestore.instance
      .collection(kUsers)
      .snapshots()
      .map((users) => UsersProvider.fromMap(users));
}
