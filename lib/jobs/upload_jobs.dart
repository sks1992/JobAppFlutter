import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:uuid/uuid.dart';

import '../util/constants.dart';
import '../widgets/bottom_navigation_bar.dart';

class UploadJobScreen extends StatefulWidget {
  const UploadJobScreen({Key? key}) : super(key: key);

  @override
  State<UploadJobScreen> createState() => _UploadJobScreenState();
}

class _UploadJobScreenState extends State<UploadJobScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  DateTime? pickedDateTime;
  Timestamp? deadlineDateTimeStamp;

  final TextEditingController _jobCategoryController =
      TextEditingController(text: "Select Job Category");
  final TextEditingController _jobTitleController = TextEditingController();
  final TextEditingController _jobDescriptionController =
      TextEditingController();
  final TextEditingController _jobDeadlineDateController =
      TextEditingController(text: "Job Deadline Data");

  @override
  void dispose() {
    super.dispose();
    _jobCategoryController.dispose();
    _jobTitleController.dispose();
    _jobDescriptionController.dispose();
    _jobDeadlineDateController.dispose();
  }

  Widget _textTitles({required String label}) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Text(
        label,
        style: const TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _textFormField({
    required String valueKey,
    required TextEditingController controller,
    required bool enabled,
    required Function fct,
    required int maxLength,
  }) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: InkWell(
        onTap: () {
          fct();
        },
        child: TextFormField(
          controller: controller,
          validator: (value) {
            if (value!.isEmpty) {
              return "Value is Missing";
            }
            return null;
          },
          enabled: enabled,
          key: ValueKey(valueKey),
          style: const TextStyle(
            color: Colors.white,
          ),
          maxLines: valueKey == "JobDescription" ? 3 : 1,
          maxLength: maxLength,
          decoration: const InputDecoration(
            filled: true,
            fillColor: Colors.black54,
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            focusedBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.green)),
            errorBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.red)),
          ),
        ),
      ),
    );
  }

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
                          _jobCategoryController.text = jobCategoryList[index];
                        });
                        Navigator.pop(context);
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
                  "Cancel",
                  style: TextStyle(
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          );
        });
  }

  void _pickedDateDialog() async {
    pickedDateTime = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now().subtract(
        const Duration(days: 0),
      ),
      lastDate: DateTime(2100),
    );

    if (pickedDateTime != null) {
      setState(() {
        _jobDeadlineDateController.text =
            '${pickedDateTime!.day} - ${pickedDateTime!.month} - ${pickedDateTime!.year}';

        deadlineDateTimeStamp = Timestamp.fromMicrosecondsSinceEpoch(
            pickedDateTime!.millisecondsSinceEpoch);
      });
    }
  }

  void _uploadTask() async {
    final jobId = const Uuid().v4();

    User? user = FirebaseAuth.instance.currentUser;
    final _uid = user!.uid;
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      if (_jobDeadlineDateController.text == "Choose job Deadline date" ||
          _jobCategoryController.text == "Choose job category") {
        GlobalMethod.showErrorDialog(
          error: "Please Pick Everything",
          context: context,
        );
        return;
      }
      setState(() {
        _isLoading = true;
      });
      try {
        await FirebaseFirestore.instance.collection("jobs").doc(jobId).set({
          'jobId': jobId,
          'uploadedId': _uid,
          'email': user.email,
          'jobTitle': _jobTitleController.text,
          'jobDescription': _jobDescriptionController.text,
          'deadlineDate': _jobDeadlineDateController.text,
          'deadlineDateTimeStamp': deadlineDateTimeStamp,
          'jobCategory': _jobCategoryController.text,
          'jobComments': [],
          'recruitment': true,
          'createdAt': Timestamp.now(),
          'name': name,
          'userImage': userImage,
          'location': location,
          'applicants': 0,
        });

        await Fluttertoast.showToast(
          msg: "The Task has Been uploaded",
          toastLength: Toast.LENGTH_LONG,
          backgroundColor: Colors.grey,
          fontSize: 18.0,
        );

        _jobTitleController.clear();
        _jobDescriptionController.clear();
        setState(() {
          _jobCategoryController.text = "Choose job category";
          _jobDeadlineDateController.text = "Choose job deadline date";
        });
      } catch (error) {
        setState(() {
          _isLoading = false;
        });
        GlobalMethod.showErrorDialog(error: error.toString(), context: context);
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      print("Its not valid");
    }
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
          indexNum: 2,
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.white10,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    const Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          "Please Fill All Fields",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _textTitles(label: "Job Category :"),
                            _textFormField(
                              valueKey: "JobCategory",
                              controller: _jobCategoryController,
                              enabled: false,
                              fct: () {
                                _showTextCategoryDialog(size: size);
                              },
                              maxLength: 100,
                            ),
                            _textTitles(label: "Job Title :"),
                            _textFormField(
                              valueKey: "JobTitle",
                              controller: _jobTitleController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitles(label: "Job Description :"),
                            _textFormField(
                              valueKey: "JobDescription",
                              controller: _jobDescriptionController,
                              enabled: true,
                              fct: () {},
                              maxLength: 100,
                            ),
                            _textTitles(label: "Job DeadLine Date :"),
                            _textFormField(
                              valueKey: "Deadline",
                              controller: _jobDeadlineDateController,
                              enabled: false,
                              fct: () {
                                _pickedDateDialog();
                              },
                              maxLength: 100,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: _isLoading
                            ? const CircularProgressIndicator()
                            : ElevatedButton(
                                onPressed: () {
                                  _uploadTask();
                                },
                                child: const Text(
                                  "Post Now",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                      ),
                    )
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
