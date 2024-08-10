import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:newtok_task/USER/WeatherReportScreen.dart';


class UploadExcelScreen extends StatefulWidget {
  @override
  _UploadExcelScreenState createState() => _UploadExcelScreenState();
}

class _UploadExcelScreenState extends State<UploadExcelScreen> {
  bool _isUploading = false;

  Future<void> uploadFile() async {
    setState(() {
      _isUploading = true;
    });

    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      File file = File(result.files.single.path!);
      try {
        final storageRef = FirebaseStorage.instance.ref().child('uploads/${result.files.single.name}');
        final uploadTask = storageRef.putFile(file);

        await uploadTask;
        print('File Uploaded');

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => WeatherReportScreen(fileName: result.files.single.name),
          ),
        );
      } catch (e) {
        print('Error uploading file: $e');
      }
    }

    setState(() {
      _isUploading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('UPLOAD EXCEL FILE')),
      body: Column(
        children: [
          SizedBox(height: 200,),
          Text("Upload Your file here",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22
            ),),
          SizedBox(height: 40,),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent[100],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: _isUploading ? null : uploadFile,
              child: _isUploading ? CircularProgressIndicator() : Text('Upload Excel File',
                style:TextStyle(
                  color: Colors.white
                ) ,),
            ),
          ),
        ],
      ),
    );
  }
}

