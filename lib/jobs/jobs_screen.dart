import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/search/search_job.dart';
import 'package:job_clone_app_flutter/widgets/job_widget.dart';

import '../util/constants.dart';
import '../widgets/bottom_navigation_bar.dart';

class JobsScreen extends StatefulWidget {
  const JobsScreen({Key? key}) : super(key: key);

  @override
  State<JobsScreen> createState() => _JobsScreenState();
}

class _JobsScreenState extends State<JobsScreen> {
  String? jobCategoryFilter;

  void _showTextCategoryDialog({required Size size}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Job category",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                color: Colors.white,
              ),
            ),
            content: SizedBox(
              width: size.width * 0.9,
              child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: jobCategoryList.length,
                  itemBuilder: (context, index) {
                    return InkWell(
                      onTap: () {
                        setState(() {
                          jobCategoryFilter = jobCategoryList[index];
                        });
                        Navigator.canPop(context)
                            ? Navigator.pop(context)
                            : null;
                      },
                      child: Row(
                        children: [
                          const Icon(
                            Icons.arrow_right_alt_outlined,
                            color: Colors.grey,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              jobCategoryList[index],
                              style: const TextStyle(
                                  fontSize: 16, color: Colors.grey),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "Close",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    jobCategoryFilter = null;
                  });
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "Cancel Filter",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  @override
  void initState() {
    super.initState();
    GlobalMethod globalMethod = GlobalMethod();
    globalMethod.getMyData();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
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
          indexNum: 0,
        ),
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
          title: const Text("Job Screen"),
          centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SearchJobScreen(),
                  ),
                );
              },
              icon: const Icon(
                Icons.search,
                color: Colors.black,
              ),
            ),
          ],
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              _showTextCategoryDialog(size: size);
            },
            icon: const Icon(
              Icons.filter_list_rounded,
              color: Colors.black,
            ),
          ),
        ),
        body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: FirebaseFirestore.instance
              .collection("jobs")
              .where('jobCategory', isEqualTo: jobCategoryFilter)
              .where('recruitment', isEqualTo: true)
              .orderBy('createdAt', descending: false)
              .snapshots(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.connectionState == ConnectionState.active) {
              if (snapshot.data?.docs.isNotEmpty == true) {
                return ListView.builder(
                    itemCount: snapshot.data?.docs.length,
                    itemBuilder: (BuildContext context, int index) {
                      return JobWidget(
                        jobTitle: snapshot.data?.docs[index]['jobTitle'] ?? "",
                        jobDescription:
                            snapshot.data?.docs[index]['jobDescription'] ?? "",
                        jobCategory:
                            snapshot.data?.docs[index]['jobCategory'] ?? "",
                        jobId: snapshot.data?.docs[index]['jobId'] ?? "",
                        uploadedBy:
                            snapshot.data?.docs[index]['uploadedBy'] ?? "",
                        userImage:
                            snapshot.data?.docs[index]['userImage'] ?? "",
                        name: snapshot.data?.docs[index]['name'] ?? "",
                        recruitment:
                            snapshot.data?.docs[index]['recruitment'] ?? false,
                        email: snapshot.data?.docs[index]['email'] ?? "",
                        location: snapshot.data?.docs[index]['location'] ?? "",
                      );
                    });
              } else {
                return const Center(
                  child: Text("There is No Jobs"),
                );
              }
            }
            return const Center(
              child: Text(
                "Something went wrong",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30),
              ),
            );
          },
        ),
      ),
    );
  }
}
