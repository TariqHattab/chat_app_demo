import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../core/provider/users_provider.dart';
import '../screens/chat_screen.dart';

class Users extends StatelessWidget {
  const Users({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UsersProvider _usersProvider = context.watch<UsersProvider>();
    List<UserModel> users = _usersProvider.users;
    return _usersProvider.isLoading
        ? const CircularProgressIndicator()
        : ListView.builder(
            itemCount: users.length,
            itemBuilder: (context, index) {
              UserModel user = users[index];
              String firstLatter =
                  user.username?.isNotEmpty ?? false ? user.username![0] : 'N';

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (ctx) => ChatScreen(otherUser: user),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    child: Text(firstLatter.toUpperCase()),
                  ),
                  title: Text(user.username ?? 'no username'),
                  subtitle: Text(user.email ?? 'no email'),
                ),
              );
            });
  }
}
