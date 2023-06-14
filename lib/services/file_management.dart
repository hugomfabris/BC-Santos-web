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

  upload(FilePickerResult? file, String shipName, String type,
      DateTime? inspectionDate) async {
    try {
      if (file != null) {
        final selecedFile = file.files.first.bytes;
        final storageRef =
            FirebaseStorage.instance.ref().child('gs://bc-santos.appspot.com/');
        final fileRef = storageRef.child(
            '${type}s/${dateFormat.format(inspectionDate!)} - $type ${shipName.trim()}.pdf');
        final uploadTask = fileRef.putData(selecedFile!);
        final snapshot = await uploadTask;
        final checklistUrl = await snapshot.ref.getDownloadURL();
        return checklistUrl;
      } else {
        print('O usuário cancelou a seleção de arquivos');
      }
    } catch (e) {
      print(e);
    }
  }

  uploadPlan(FilePickerResult? file, String planType) async {
  try {
    if (file != null) {
      final selectedFile = file.files.first.bytes;
      final storageRef = FirebaseStorage.instance.ref();
      
      // Deletar pasta de referência
      try {
        await storageRef.child('Plano de ação/$planType/').delete();
      } catch (e) {
        print(e);
        print('A pasta não existe');
      }
      
      // Crie uma nova pasta de referência
      final newFolderPath = 'Plano de ação/$planType/';
      await storageRef.child(newFolderPath).putString('');
      
      final fileRef = storageRef.child(
          '$newFolderPath${dateFormat.format(DateTime.now())} - ${planType.trim()}.pdf');
      final uploadTask = fileRef.putData(selectedFile!);
      final snapshot = await uploadTask;
      
      final planUrl = await snapshot.ref.getDownloadURL();
      return planUrl;
    } else {
      print('O usuário cancelou a seleção de arquivos');
    }
  } catch (e) {
    print(e);
  }
}


  updatePlan(String type) async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('plans')
        .where('planType', isEqualTo: type)
        .get();
    final documents = querySnapshot.docs;
    if (documents.isNotEmpty) {
      final documentId = documents.first.id;
      final documentReference =
          FirebaseFirestore.instance.collection('plans').doc(documentId);
      await documentReference.update({'url': 'teste'});
    }
  }
}
