import 'package:flutter/material.dart';
import 'package:job_clone_app_flutter/search/search_job.dart';

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
                        print("jobCategoryList:: ${jobCategoryList[index]}");
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
        body: Container(),
      ),
    );
  }
}
