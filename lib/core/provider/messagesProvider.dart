import 'package:chat_app_demo/core/models/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../utils/consts.dart';

class MessagesProvider {
  List<MessageModel> messages = [];
  bool isLoading = false;

  MessagesProvider({
    this.messages = const [],
    this.isLoading = true,
  });

  MessagesProvider.fromMap(QuerySnapshot<Map<String, dynamic>> usersSnapShots) {
    isLoading = false;
    final currentUser = FirebaseAuth.instance.currentUser;
    for (var doc in usersSnapShots.docs) {
      messages.add(MessageModel.fromMap(doc.data(), doc.id));
    }
  }
}

//Fetching  users
Stream<MessagesProvider> getMessagesStream({required String groupId}) {
  print('---------------------started to get users');
  return FirebaseFirestore.instance
      .collection(kChat)
      .doc(groupId)
      .collection(kMessages)
      .orderBy('sentAt', descending: true)
      .snapshots()
      .map((users) => MessagesProvider.fromMap(users));
}
