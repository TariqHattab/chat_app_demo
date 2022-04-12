import 'package:chat_app_demo/widgets/groups_widget.dart';
import 'package:flutter/material.dart';

import '../widgets/users_widget.dart';
import '../widgets/logout_button.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'List Screen',
            ),
            actions: const [LogoutButton()],
            bottom: const TabBar(tabs: [
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Users'),
              ),
              Padding(
                padding: EdgeInsets.all(10.0),
                child: Text('Groups'),
              ),
            ]),
          ),
          body: const TabBarView(
            children: [
              Users(),
              Groups(),
            ],
          )),
    );
  }
}
