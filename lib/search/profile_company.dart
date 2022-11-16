import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../user_state.dart';
import '../widgets/bottom_navigation_bar.dart';

class ProfileCompanyScreen extends StatefulWidget {
  const ProfileCompanyScreen({Key? key}) : super(key: key);

  @override
  State<ProfileCompanyScreen> createState() => _ProfileCompanyScreenState();
}

class _ProfileCompanyScreenState extends State<ProfileCompanyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.deepOrange.shade300,
            Colors.blueAccent,
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          stops: const [0.2, 0.9],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: BottomNavBar(indexNum: 3,),
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.deepOrange.shade300,
                  Colors.blueAccent,
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: const [0.2, 0.9],
              ),
            ),
          ),
          title: const Text("Profile Screen"),
          centerTitle: true,

        ),
      ),
    );
  }
}
