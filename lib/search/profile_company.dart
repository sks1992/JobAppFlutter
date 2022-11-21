import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/user_state.dart';

import '../widgets/bottom_navigation_bar.dart';

class ProfileCompanyScreen extends StatefulWidget {
  const ProfileCompanyScreen({Key? key, required this.userId})
      : super(key: key);

  final String userId;

  @override
  State<ProfileCompanyScreen> createState() => _ProfileCompanyScreenState();
}

class _ProfileCompanyScreenState extends State<ProfileCompanyScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? name;
  String email = '';
  String phoneNumber = '';
  String imageUrl = '';
  String joinedAt = '';
  bool _isLoading = false;
  bool _isSameUser = false;

  void getUserData() async {
    try {
      _isLoading = true;
      final DocumentSnapshot userDoc = await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .get();

      if (userDoc == null) {
        return;
      } else {
        setState(() {
          name = userDoc.get('name');
          email = userDoc.get('email');
          phoneNumber = userDoc.get('phoneNumber');
          imageUrl = userDoc.get('userImage');
          Timestamp joinedAtTimeStamp = userDoc.get('createdAt');
          var joinedDate = joinedAtTimeStamp.toDate();
          joinedAt = '${joinedDate.day}/${joinedDate.month}/${joinedDate.year}';
        });

        User? user = _auth.currentUser;
        final _uid = user!.uid;
        setState(() {
          _isSameUser = _uid == widget.userId;
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserData();
  }

  Widget userInfo({
    required IconData icon,
    required String content,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Text(
            content,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
        bottomNavigationBar: BottomNavBar(
          indexNum: 3,
        ),
        // appBar: AppBar(
        //   flexibleSpace: Container(
        //     decoration: BoxDecoration(
        //       gradient: LinearGradient(
        //         colors: [
        //           Colors.deepOrange.shade300,
        //           Colors.blueAccent,
        //         ],
        //         begin: Alignment.centerLeft,
        //         end: Alignment.centerRight,
        //         stops: const [0.2, 0.9],
        //       ),
        //     ),
        //   ),
        //   title: const Text("Profile Screen"),
        //   centerTitle: true,
        // ),
        body: SafeArea(
          child: Center(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 0),
                      child: Stack(
                        children: [
                          Card(
                            color: Colors.white10,
                            margin: const EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 100),
                                  Align(
                                    alignment: Alignment.center,
                                    child: Text(
                                      name == null ? "Name Here" : name!,
                                      style: const TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 30),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(10.0),
                                    child: Text(
                                      "Account Information",
                                      style: TextStyle(
                                        fontSize: 24,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: userInfo(
                                      icon: Icons.email,
                                      content: email,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: userInfo(
                                      icon: Icons.phone,
                                      content: phoneNumber,
                                    ),
                                  ),
                                  const SizedBox(height: 20),
                                  const Divider(
                                    thickness: 1,
                                    color: Colors.white,
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {
                                          _auth.signOut();
                                          Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                              builder: (_) => const UserState(),
                                            ),
                                          );
                                        },
                                        child: Row(
                                          children: const [
                                            Text(
                                              "Logout",
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            SizedBox(width: 10),
                                            Icon(Icons.logout)
                                          ],
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: size.width * 0.28,
                                height: size.width * 0.28,
                                decoration: BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    width: 8,
                                    color: Theme.of(context)
                                        .scaffoldBackgroundColor,
                                  ),
                                  image: DecorationImage(
                                    image: NetworkImage(
                                      imageUrl ??
                                          "https://w7.pngwing.com/pngs/340/946/png-transparent-avatar-user-computer-icons-software-developer-avatar-child-face-heroes.png",
                                    ),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                child: Container(),
                              )
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
