import 'package:cloud_firestore/cloud_firestore.dart';

class Pet {
  late String owner;
  late String name;
  late String breed;
  late String image;
  late String description;
  late String age;
  late String sex;
  late String color;
  late String id;
  late String adress;
  late String ownerImage;
  late String type;
  late String docID;
  late String phone;
  late bool isactive;
  late Timestamp createdAt;
  late bool isadopted;

  Pet();

  Pet.fromMap(Map<String, dynamic> data) {
    owner = data['owner'];
    name = data['name'];
    breed = data['breed'];
    image = data['image'];
    description = data['description'];
    sex = data['sex'];
    age = data['age'];
    color = data['color'];
    id = data['id'];
    adress = data['adress'];
    ownerImage = data['ownerImage'];
    type = data['type'];
    docID = data['docID'];
    phone = data['phone'];
    isactive = data['isactive'];
    createdAt = data['creadtedAt'];
    isadopted = data['isadopted'];
  }
  Map<String, dynamic> toMap() {
    return {
      'owner': owner,
      'name': name,
      'breed': breed,
      'image': image,
      'description': description,
      'sex': sex,
      'age': age,
      'color': color,
      'id': id,
      'adress': adress,
      'ownerImage': ownerImage,
      'type': type,
      'docID': docID,
      'phone': phone,
      'isactive': isactive,
      'createdAt': createdAt,
      'isadopted': isadopted,
    };
  }
}
