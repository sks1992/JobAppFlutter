import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/jobs/jobs_screen.dart';
import 'package:job_clone_app_flutter/jobs/upload_jobs.dart';
import 'package:job_clone_app_flutter/search/profile_company.dart';
import 'package:job_clone_app_flutter/search/search_companies.dart';
import 'package:job_clone_app_flutter/user_state.dart';

class BottomNavBar extends StatelessWidget {
  BottomNavBar({Key? key, required this.indexNum}) : super(key: key);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  int indexNum = 0;

  void logoutFun(BuildContext context) async {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.black54,
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.white,
                    size: 36,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Sign Out",
                    style: TextStyle(color: Colors.white, fontSize: 28),
                  ),
                ),
              ],
            ),
            content: const Text(
              "Do You Want To Logout?",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "No",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await _auth.signOut();
                  // ignore: use_build_context_synchronously
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                  // ignore: use_build_context_synchronously
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const UserState(),
                    ),
                  );
                },
                child: const Text(
                  "Yes",
                  style: TextStyle(color: Colors.green, fontSize: 18),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return CurvedNavigationBar(

      color: Colors.deepOrange.shade400,
      backgroundColor: Colors.blueAccent,
      buttonBackgroundColor: Colors.deepOrange.shade300,
      height: 50,
      items: const [
        Icon(
          Icons.list,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.search,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.add,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.person_add_alt_1_outlined,
          size: 19,
          color: Colors.black,
        ),
        Icon(
          Icons.logout,
          size: 19,
          color: Colors.black,
        ),
      ],
      animationDuration: const Duration(
        seconds: 3,
      ),
      animationCurve: Curves.bounceInOut,
      index: indexNum,
      onTap: (index) {
        if (index == 0) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const JobsScreen(),
            ),
          );
        }
        if (index == 1) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AllCompanyScree(),
            ),
          );
        }
        if (index == 2) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const UploadJobScreen(),
            ),
          );
        }
        if (index == 3) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const ProfileCompanyScreen(),
            ),
          );
        }
        if (index == 4) {
          logoutFun(context);
        }
      },
    );
  }
}
