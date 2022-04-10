import 'package:chat_app_demo/screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_demo/screens/chat_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

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
        ],
        child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'FlutterChat',
            theme: ThemeData(
              backgroundColor: const Color.fromARGB(255, 193, 157, 255),
              buttonTheme: ButtonTheme.of(context).copyWith(
                buttonColor: Colors.deepPurple,
                textTheme: ButtonTextTheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
              colorScheme:
                  ColorScheme.fromSwatch(primarySwatch: Colors.deepPurple)
                      .copyWith(secondary: Colors.deepPurple),
            ),
            home: Consumer<User?>(
              builder: ((context, user, _) {
                if (user != null) {
                  return ChatScreen();
                }
                return AuthScreen();
              }),
            )));
  }
}
