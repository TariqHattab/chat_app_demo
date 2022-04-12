import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LogoutButton extends StatelessWidget {
  const LogoutButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      underline: Container(),
      icon: const Icon(
        Icons.more_vert,
        color: Colors.white,
      ),
      items: [
        DropdownMenuItem(
          child: Container(
            child: Row(
              children: const [
                Icon(Icons.exit_to_app),
                SizedBox(
                  width: 8,
                ),
                Text('logout'),
              ],
            ),
          ),
          value: 'logout',
        )
      ],
      onChanged: (itemIdentifier) {
        if (itemIdentifier == 'logout') {
          FirebaseAuth.instance.signOut();
        }
      },
    );
  }
}
