import 'package:chat_app_demo/core/provider/groups_provider.dart';
import 'package:chat_app_demo/screens/auth_screen.dart';
import 'package:chat_app_demo/screens/users_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

import 'core/provider/users_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          StreamProvider<User?>(
              create: (ctx) => FirebaseAuth.instance.authStateChanges(),
              initialData: null),
          StreamProvider<UsersProvider>(
              create: (ctx) => getUsers(), initialData: UsersProvider()),
          StreamProvider<GroupsProvider>(
              create: (ctx) => getUserGroups(), initialData: GroupsProvider()),
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FlutterChat',
            theme: ThemeData(
                primaryColor: Colors.red,
                backgroundColor: const Color.fromARGB(255, 180, 84, 15),
                buttonTheme: ButtonTheme.of(context).copyWith(
                  buttonColor: Colors.deepOrange,
                  textTheme: ButtonTextTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                primarySwatch: Colors.deepOrange),
            home: Consumer<User?>(
              builder: ((context, user, _) {
                if (user != null) {
                  return const UsersScreen();
                }
                return AuthScreen();
              }),
            )));
  }
}
