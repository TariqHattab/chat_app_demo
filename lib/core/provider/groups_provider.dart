import 'package:chat_app_demo/core/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/consts.dart';

class GroupModel {
  late String id;
  String? createdBy;
  List<dynamic> members = [];
  var modifiedAt;
  String? name;
  MessageModel? recentMessage;

  GroupModel({
    required this.id,
    this.createdBy,
    this.members = const [],
    this.modifiedAt,
    this.name,
    this.recentMessage,
  });

  GroupModel.fromMap(Map<String, dynamic> group, this.id) {
    print(group);
    createdBy = group['createdBy'];
    if (group['members'] is List) {
      members = group['members'];
    }
    modifiedAt = group['modifiedAt'];
    name = group['name'];
    if (group['recentMessage'] != null) {
      recentMessage = MessageModel.fromMap(
        group['recentMessage'],
        group['recentMessage']['id'],
      );
    }
  }
  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = {};

    data['createdBy'] = createdBy;
    data['members'] = members;
    data['modifiedAt'] = modifiedAt;
    data['name'] = name;
    data['recentMessage'] = recentMessage?.toMap();

    return data;
  }
}

class GroupsProvider {
  List<GroupModel> groups = [];
  GroupsProvider();

  GroupsProvider.fromMap(QuerySnapshot<Map<String, dynamic>> groupsSnapShots) {
    print('groupss----------------------are');
    print('groupsSnapShotse');
    for (var doc in groupsSnapShots.docs) {
      print(doc.id);
      print(doc.data());
      groups.add(GroupModel.fromMap(doc.data(), doc.id));
    }
  }
}

//Fetching  groups
Stream<GroupsProvider> getUserGroups() {
  print('---------------------started to get groups');
  final currentUser = FirebaseAuth.instance.currentUser;
  print(currentUser?.uid);
  if (currentUser == null) {
    //get all groups
    return FirebaseFirestore.instance
        .collection(kGroups)
        .snapshots()
        .map((groups) => GroupsProvider.fromMap(groups));
  } else {
    //get groups the user is a member of
    return FirebaseFirestore.instance
        .collection(kGroups)
        .where("members", arrayContains: currentUser.uid)
        .snapshots()
        .map((groups) => GroupsProvider.fromMap(groups));
  }
}
