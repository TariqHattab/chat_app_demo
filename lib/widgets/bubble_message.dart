import 'package:flutter/material.dart';

class BubbleMessage extends StatelessWidget {
  final String message;
  final bool isMe;
  final String username;
  final String userImageUrl;

  const BubbleMessage(
      {Key? key,
      required this.message,
      required this.isMe,
      required this.username,
      required this.userImageUrl})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
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
                    username,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.green),
                  ),
                  Text(
                    message,
                    textAlign: isMe ? TextAlign.end : TextAlign.start,
                    style: TextStyle(color: isMe ? Colors.black : Colors.green),
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
            backgroundImage: NetworkImage(userImageUrl),
          )),
    ]);
  }
}
