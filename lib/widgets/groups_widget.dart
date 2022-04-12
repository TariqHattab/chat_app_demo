import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/provider/groups_provider.dart';
import '../screens/chat_screen.dart';

class Groups extends StatelessWidget {
  const Groups({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var groups = context.watch<GroupsProvider>().groups;
    return ListView.builder(
        itemCount: groups.length,
        itemBuilder: (context, index) {
          var group = groups[index];

          return GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (ctx) => ChatScreen(groupModel: group),
                ),
              );
            },
            child: ListTile(
              leading: const CircleAvatar(
                child: Text("G"),
              ),
              title:
                  Text(group.recentMessage?.messageText ?? 'no massages Yet'),
              subtitle:
                  Text((group.modifiedAt as Timestamp).toDate().toString()),
            ),
          );
        });
  }
}
