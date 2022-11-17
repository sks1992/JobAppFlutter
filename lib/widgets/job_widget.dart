import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:job_clone_app_flutter/jobs/job_details.dart';
import 'package:job_clone_app_flutter/util/constants.dart';

class JobWidget extends StatefulWidget {
  const JobWidget({
    Key? key,
    required this.jobTitle,
    required this.jobDescription,
    required this.jobCategory,
    required this.jobId,
    required this.uploadedBy,
    required this.userImage,
    required this.name,
    required this.recruitment,
    required this.email,
    required this.location,
  }) : super(key: key);

  final String jobTitle;
  final String jobDescription;
  final String jobCategory;
  final String jobId;
  final String uploadedBy;
  final String userImage;
  final String name;
  final bool recruitment;
  final String email;
  final String location;

  @override
  State<JobWidget> createState() => _JobWidgetState();
}

class _JobWidgetState extends State<JobWidget> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  _deleteDialog() {
    User? _user = _auth.currentUser;
    final _uid = _user!.uid;
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            actions: [
              TextButton(
                onPressed: () async {
                  try {
                    if (widget.uploadedBy == _uid) {
                      await FirebaseFirestore.instance
                          .collection("jobs")
                          .doc(widget.jobId)
                          .delete();

                      await Fluttertoast.showToast(
                        msg: "Job Has Been Deleted",
                        toastLength: Toast.LENGTH_LONG,
                        backgroundColor: Colors.grey,
                        fontSize: 18,
                      );
                      // ignore: use_build_context_synchronously
                      Navigator.canPop(context) ? Navigator.pop(context) : null;
                    } else {
                      GlobalMethod.showErrorDialog(
                          error: "You Can not prefers this action",
                          context: context);
                    }
                  } catch (error) {
                    GlobalMethod.showErrorDialog(
                        error: "This task can not be deleted",
                        context: context);
                  }
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      Icons.delete,
                      color: Colors.red,
                    ),
                    Text(
                      "Delete",
                      style: TextStyle(color: Colors.red),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white24,
      elevation: 0,
      margin: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 8,
      ),
      child: ListTile(
        onTap: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => JobDetailScreen(
                uploadedBy: widget.uploadedBy,
                jobId: widget.jobId,
              ),
            ),
          );
        },
        onLongPress: () {
          _deleteDialog();
        },
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10,
        ),
        leading: Container(
          padding: const EdgeInsets.only(
            right: 12,
          ),
          decoration: const BoxDecoration(
            border: Border(
              right: BorderSide(width: 1),
            ),
          ),
          child: widget.userImage == ""
              ? Image.network(
                  "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQkfF6nBhidhIzL330CYtg70I8tpDBGJ2YjBPnE9D9gY0iLmGu563WBIab4KBexSDv7kG8&usqp=CAU")
              : Image.network(widget.userImage),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.jobTitle,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.amber,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              widget.jobCategory,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black26,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              widget.userImage == "" ? "Demo Name" : widget.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(
              height: 8,
            ),
            Text(
              widget.jobDescription,
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 15,
              ),
            ),
          ],
        ),
        trailing: const Icon(
          Icons.keyboard_arrow_right,
          size: 30,
          color: Colors.black,
        ),
      ),
    );
  }
}
