import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:kch_kovm/utils/build_home_button.dart';
import 'package:kch_kovm/utils/build_style_button.dart';
import 'package:open_file/open_file.dart';

class FilePickerScreen extends StatefulWidget {
  const FilePickerScreen({super.key});

  @override
  State<FilePickerScreen> createState() => _FilePickerScreenState();
}

class _FilePickerScreenState extends State<FilePickerScreen> {
  void openFile() async {
    try {
       FilePickerResult? resultFile = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['xls', 'xlsx'],
      );
      if (resultFile != null) {
        PlatformFile file = resultFile.files.first;
        // Open the selected file with the Excel app
        await OpenFile.open(file.path);
      } else {
        //do something else
      }
    } catch (e) {
      throw Exception(e);
    }
   
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: homeButton(context, 'Fichier'), backgroundColor: Colors.blue),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: (){
              openFile();
            },
            style: buildStyle(Colors.blueAccent, 200, 50),
            child: const Text(
              'Ouvrir un Fichier',
              style: TextStyle(color: Color.fromRGBO(255, 255, 255, 1)),
            ),
          ),
        ),
      ),
    );
  }
}
