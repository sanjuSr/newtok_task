import 'package:flutter/material.dart';
import 'package:newtok_task/USER/UploadExcelScreen.dart';

class FooterWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      color: Colors.grey[200],
      child: Center(
        child: Column(
          children: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => UploadExcelScreen()),
                );
              },
              child: Text("Upload",
                style: TextStyle(
                    color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}
