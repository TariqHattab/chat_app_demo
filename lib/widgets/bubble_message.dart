import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/provider/users_provider.dart';

class BubbleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;

  const BubbleMessage({
    Key? key,
    required this.message,
    required this.isMe,
    required this.username,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    UserModel? userInfo;
    if (username != 'Me') {
      userInfo = context.read<UsersProvider>().getOtherUserInfo(username);
    }
    return Stack(clipBehavior: Clip.none, children: [
      Row(
          mainAxisAlignment:
              isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: isMe
                    ? Colors.grey[300]
                    : Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(12),
                  topRight: const Radius.circular(12),
                  bottomLeft: !isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                  bottomRight: isMe
                      ? const Radius.circular(0)
                      : const Radius.circular(12),
                ),
              ),
              width: 140,
              margin: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  Text(
                    userInfo?.username ?? 'Me',
                    maxLines: 1,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.white),
                  ),
                ],
              ),
            ),
          ]),
      Positioned(
          top: 0,
          right: isMe ? 125 : null,
          left: isMe ? null : 125,
          child: CircleAvatar(
            child: Text((userInfo?.username ?? 'Me')[0].toUpperCase()),
          )),
    ]);
  }
}
