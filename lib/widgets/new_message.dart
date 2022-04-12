import 'package:chat_app_demo/core/database/firebase_handler.dart';
import 'package:chat_app_demo/core/models/message.dart';
import 'package:chat_app_demo/core/provider/groups_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../core/provider/users_provider.dart';
import '../core/utils/consts.dart';
import '../core/utils/functions.dart';

class NewMessage extends StatefulWidget {
  UserModel? otherUser;
  GroupModel? groupModel;
  NewMessage(this.otherUser, this.groupModel, {Key? key}) : super(key: key);

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _controller = TextEditingController();
  String _enteredMessage = '';

  void _sendMessage() async {
    FocusScope.of(context).unfocus();
    final user = FirebaseAuth.instance.currentUser;
    print('user---------$user');
    if (user == null) {
      return;
    }

    if (widget.groupModel != null) {
      var messsage = MessageModel(
        id: DateTime.now().toIso8601String(),
        messageText: _enteredMessage,
        sentAt: DateTime.now(),
        sentBy: user.uid,
      );
      FirebaseFirestore.instance
          .collection(kChat)
          .doc(widget.groupModel!.id)
          .collection(kMessages)
          .add(messsage.toMap());
      FirebaseFirestore.instance
          .collection(kGroups)
          .doc(widget.groupModel?.id)
          .update({
        'recentMessage': messsage.toMap(),
        'modifiedAt': DateTime.now(),
      });
    } else {
      var messsage = MessageModel(
        id: DateTime.now().toIso8601String(),
        messageText: _enteredMessage,
        sentAt: DateTime.now(),
        sentBy: user.uid,
      );
      String groupId = getGroupId(user, widget.otherUser!);

      var group = GroupModel(
        id: groupId,
        createdBy: user.uid,
        members: [user.uid, widget.otherUser!.id],
        modifiedAt: DateTime.now(),
        name:
            ((user.uid) + ' to ' + (widget.otherUser?.username ?? 'someUser')),
        recentMessage: messsage,
      );
      FirebaseHandler().createGroup(group);
      FirebaseFirestore.instance
          .collection(kChat)
          .doc(group.id)
          .collection(kMessages)
          .add(messsage.toMap());
    }

    // FirebaseFirestore.instance.collection('chat').add(
    //   {
    //     'text': _enteredMessage,
    //     'sentBy': user?.uid,
    //     'sentAt': userData.username,
    //   },
    // );
    _controller.clear();
    setState(() {
      _enteredMessage = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      //color: Theme.of(context).primaryColor,
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: const InputDecoration(
                labelText: 'message',
              ),
              onChanged: (value) {
                setState(() {
                  _enteredMessage = value;
                });
              },
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            color: Colors.deepOrange,
            onPressed: _enteredMessage.trim().isEmpty ? null : _sendMessage,
          ),
        ],
      ),
    );
  }
}
