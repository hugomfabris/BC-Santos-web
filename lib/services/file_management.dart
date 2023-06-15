import 'dart:html';
// import 'package:url_launcher/url_launcher.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FileManagement extends StatelessWidget {
  FileManagement({Key? key}) : super(key: key);
  final DateFormat dateFormat = DateFormat("dd.MM.yyyy");

  @override
  Widget build(BuildContext context) {
    return Container();
  }

//   void openFile(String url) async {
//   final fileReference = FirebaseStorage.instance.refFromURL(url);
//   final downloadURL = await fileReference.getDownloadURL();

//   launchUrl(downloadURL);
// }

// void launchUrl(String url) async {
//   if (await canLaunchUrl (url as Uri)) {
//     launchUrl (url);
//   } else {
//     throw 'Não foi possível abrir o arquivo';
//   }
// }

  void openFile(url) async {
    try {
      final fileReference = FirebaseStorage.instance.refFromURL(url);
      final downloadURL = await fileReference.getDownloadURL();
      final anchorElement = AnchorElement(href: downloadURL)
        ..setAttribute('target', '_blank')
        ..setAttribute('rel', 'noopener noreferrer');
      anchorElement.click();
    } catch (e) {
      print(e);
    }
  }

  void setPlanPath() {
    // _setPlanPath();
  }

  Future<FilePickerResult?> pickFiles(String file) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.any,
      dialogTitle: "Selecione o $file",
    );

    return result;
  }

  uploaAndGetUrl(FilePickerResult? file, String folder,
      [DateTime? inspectionDate, String? shipName]) async {
    if (file != null) {
      // Get the file bytes and reference the firebase storage path
      final selectedFile = file.files.first.bytes;
      final storageRef = FirebaseStorage.instance.ref();

      try {
        if (folder == 'barcaças' || folder == 'rebocadores') {
          // Delete the reference folder
          try {
            final filesToDelete = await storageRef.child('Plano de ação/$folder').listAll();
            for (final file in filesToDelete.items) {
              await file.delete();
            }
          } catch (e) {
            print(e);
          }
          // Create file reference and upload the file
          final fileName =
              '${dateFormat.format(DateTime.now())} - Plano de ação ${folder.trim()}.pdf';
          // Create or reference a folder and upload the file
          final fileRef = storageRef.child('Plano de ação/$folder/$fileName');
          final uploadTask = fileRef.putData(selectedFile!);
          final snapshot = await uploadTask;
          // Get the file url and return it
          final planUrl = await snapshot.ref.getDownloadURL();
          // Update the plan url in the database
          return planUrl;
        } else if (folder == 'certificados') {
          // Create or reference a folder and upload the file
          final fileName = '${dateFormat.format(inspectionDate!)} - certificado ${shipName!.trim().toLowerCase()}.pdf';
          final fileRef = storageRef.child('$folder/$shipName/$fileName');
          // Insert the bytes format file in the folder
          final uploadTask = fileRef.putData(selectedFile!);
          final snapshot = await uploadTask;
          // Get the file url and return it
          final certificateUrl = await snapshot.ref.getDownloadURL();
          return certificateUrl;
        } else if (folder == 'checklists') {
          // Create or reference a folder and upload the file
          final fileName = '${dateFormat.format(inspectionDate!)} - checklist ${shipName!.trim().toLowerCase()}.pdf';
          final fileRef = storageRef.child('$folder/$shipName/$fileName');
          // Insert the bytes format file in the folder
          final uploadTask = fileRef.putData(selectedFile!);
          final snapshot = await uploadTask;
          // Get the file url and return it
          final checklistUrl = await snapshot.ref.getDownloadURL();
          return checklistUrl;
        }
      } catch (e) {
        print('A pasta não existe');
      }
    } else {
      print('O usuário cancelou a seleção de arquivos');
    }
  }

  Future<void> updateUrl(String type, String url) async {
    final docRef = await FirebaseFirestore.instance
        .collection('plans')
        .where('type', isEqualTo: type)
        .get();

    final updatedUrl =
        await docRef.docs[0].reference.update({'url': url}).whenComplete(() {
      print('URL atualizada com sucesso');
    }).catchError((error) {
      print('Erro ao atualizar a URL: $error');
    });
    return updatedUrl;
  }
}
