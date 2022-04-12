import 'package:chat_app_demo/core/provider/groups_provider.dart';
import 'package:chat_app_demo/core/utils/consts.dart';
import 'package:chat_app_demo/core/utils/functions.dart';
import 'package:chat_app_demo/widgets/new_message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:chat_app_demo/widgets/messages.dart';
import 'package:provider/provider.dart';

import '../core/provider/messagesProvider.dart';
import '../core/provider/users_provider.dart';

class ChatScreen extends StatefulWidget {
  UserModel? otherUser;
  GroupModel? groupModel;

  ChatScreen({Key? key, this.otherUser, this.groupModel}) : super(key: key);
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  GroupModel? _groupModel;
  bool isLoading = false;
  late String groupId;
  @override
  void initState() {
    super.initState();

    // final fbm = FirebaseMessaging.instance;
    // fbm.requestPermission();
    // FirebaseMessaging.onMessage.listen((msg) {
    //   print(msg);
    //   return;
    // });
    // FirebaseMessaging.onMessageOpenedApp.listen((msg) {
    //   print(msg);
    //   return;
    // });
  }

  @override
  void didChangeDependencies() async {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    final currentUser = FirebaseAuth.instance.currentUser;
    // print(user?.uid);
    if (currentUser == null) {
      return;
    }

    if (widget.groupModel != null) {
      _groupModel = widget.groupModel;
      groupId = _groupModel!.id;

      return;
    }
    await _getGroupModel(currentUser);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FlutterChat'),
        // actions: const [LogoutButton()],
      ),
      body: isLoading
          ? const CircularProgressIndicator()
          : Column(
              children: [
                Expanded(
                    child: StreamProvider<MessagesProvider>(
                        create: (context) =>
                            getMessagesStream(groupId: groupId),
                        initialData: MessagesProvider(),
                        child: Messages(_groupModel))),
                NewMessage(widget.otherUser, _groupModel)
              ],
            ),
    );
  }

  Future<void> _getGroupModel(User currentUser) async {
    groupId = getGroupId(currentUser, widget.otherUser!);

    setState(() {
      isLoading = true;
    });
    var group =
        await FirebaseFirestore.instance.collection(kGroups).doc(groupId).get();
    setState(() {
      isLoading = false;
    });

    print('group---------------$group');

    if (group.exists) {
      _groupModel = GroupModel.fromMap(group.data()!, group.id);
    }
  }
}
