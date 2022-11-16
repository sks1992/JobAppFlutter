import 'package:flutter/material.dart';

String loginUrlImage = "https://eskipaper.com/images/building-wallpaper-11.jpg";

List<String> jobCategoryList =[
  "Architecture and Construction",
  "Education and Training",
  "Development -Programming",
  "Business",
  "Information Technology",
  "Human Resources",
  "Marketing",
  "Design",
  "Accounting",
];

String? name="";
String? userImage="";
String? location="";

class GlobalMethod {
  static void showErrorDialog({
    required String error,
    required BuildContext context,
  }) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Row(
              children: const [
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Icon(
                    Icons.logout,
                    color: Colors.grey,
                    size: 35,
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    "Error Occurred",
                  ),
                ),
              ],
            ),
            content: Text(
              error,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontStyle: FontStyle.italic,
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.canPop(context) ? Navigator.pop(context) : null;
                },
                child: const Text(
                  "Ok",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          );
        });
  }
}
