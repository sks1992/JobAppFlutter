import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/jobs/jobs_screen.dart';
import 'package:job_clone_app_flutter/login_screen/login_screen.dart';

class UserState extends StatelessWidget {
  const UserState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, userSnapShot) {
          if (userSnapShot.data == null) {
            print("user is not logged in yet");
            return const LoginScreen();

          } else if (userSnapShot.hasData) {
            print("User is already logged in yet");
            return JobsScreen();

          } else if (userSnapShot.hasError) {
            print("has an  login error");
            return const Scaffold(
              body: Center(
                child: Text("An Error been has occored, try again"),
              ),
            );

          } else if (userSnapShot.connectionState == ConnectionState.waiting) {
            print("data is loading");
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return const Scaffold(
            body: Center(
              child: Text("Something went wrong,try again."),
            ),
          );
        });
  }
}
