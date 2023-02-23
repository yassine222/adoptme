import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FavoriteService {
  final user = FirebaseAuth.instance.currentUser;

  Future<void> infavorite(String id) {
    CollectionReference userFavorite = FirebaseFirestore.instance
        .collection('UserProfile')
        .doc(user!.uid)
        .collection('Favorite');
    return userFavorite
        .doc(id)
        .delete()
        .then((value) => print("pet infavorite"))
        .catchError((error) => print("Failed to infavorite post: $error"));
  }

  Future<void> setfavorite(
    String image,
    String name,
    String breed,
    String description,
    String ownerId,
    String ownerName,
    String sex,
    String color,
    String age,
    String adress,
    String ownerImage,
    String type,
    Timestamp timestamp,
    String phone,
    String docId,
  ) {
    CollectionReference userFavorite = FirebaseFirestore.instance
        .collection('UserProfile')
        .doc(user!.uid)
        .collection('Favorite');
    return userFavorite.doc(docId).set({
      'image': image,
      'name': name,
      'breed': breed,
      'description': description,
      'id': ownerId,
      'owner': ownerName,
      'sex': sex,
      'age': age,
      'color': color,
      'adress': adress,
      'ownerImage': ownerImage,
      'type': type,
      'createdAt': timestamp,
      'phone': phone,
      'docID': docId,
      'isadopted': false,
      'isactive': true,
    });
  }
}
