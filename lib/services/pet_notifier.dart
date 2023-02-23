import 'dart:collection';

import 'package:adoptme/Models/pet_model.dart';
import 'package:flutter/cupertino.dart';

class PetNotifier with ChangeNotifier {
  List<Pet> _petList = [];
  late Pet _currentPet;
  UnmodifiableListView<Pet> get petList => UnmodifiableListView(_petList);
  Pet get currentPet => _currentPet;

  set petList(List<Pet> petList) {
    _petList = petList;
    notifyListeners();
  }

  set currentPet(Pet pet) {
    _currentPet = pet;
    notifyListeners();
  }
}
