import 'package:chat_app_demo/core/provider/groups_provider.dart';
import 'package:chat_app_demo/core/provider/messagesProvider.dart';
import 'package:chat_app_demo/widgets/bubble_message.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Messages extends StatelessWidget {
  GroupModel? groupModel;
  Messages(this.groupModel, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _messagesProvider = context.watch<MessagesProvider>();

    var currentUser = FirebaseAuth.instance.currentUser;

    return _messagesProvider.isLoading
        ? const CircularProgressIndicator()
        : ListView.builder(
            reverse: true,
            itemCount: _messagesProvider.messages.length,
            itemBuilder: (ctx, index) {
              var message = _messagesProvider.messages[index];
              var isMe = message.sentBy == currentUser?.uid;

              return BubbleMessage(
                message: message.messageText,
                isMe: isMe,
                username: isMe ? 'Me' : message.sentBy.toString(),
                // userImageUrl: documents?[index].data()?['userImage'],
                key: ValueKey(message),
              );
            },
          );
  }
}
