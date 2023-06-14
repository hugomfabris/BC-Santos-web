import 'package:cloud_firestore/cloud_firestore.dart';

class Plan {
  Plan({this.type, this.url});

  late String? type;
  late String? url;

  Plan.fromMap(Map<String, dynamic> map) {
    type = map['type'];
    url = map['url'];
  }

  Plan.fromDocument(QueryDocumentSnapshot<Map<String, dynamic>> document) {
    type = document.data()['type'] as String;
    url = document.data()['url'] as String;
  }

  Map<String, dynamic> toFirestoreMap() {
    return {
      'type': type,
      'url': url,
    };
  }

  @override
  String toString() {
    return 'Plan{type: $type, url: $url}';
  }

  Future<void> updateUrl(type) async {
    final docRef = await FirebaseFirestore.instance
        .collection('plans')
        .where('type', isEqualTo: type)
        .get();
    
    final result = await docRef.docs[0].reference.update({'url': url}).whenComplete(() {
      print('URL atualizada com sucesso');
    }).catchError((error) {
      print('Erro ao atualizar a URL: $error');
    });
    return result;
  }
}
