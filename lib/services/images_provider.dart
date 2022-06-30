import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:universal_io/io.dart';

class ImagesProvider with ChangeNotifier {
  File? _image;
  bool _isUpdatingImage = false;
  List<File> _images = [];

  final ImagePicker _picker = ImagePicker();

  //getters
  UnmodifiableListView<File> get images => UnmodifiableListView(_images);
  File? get image => _image;
  bool get isUpdatingImage => _isUpdatingImage;

  //For removing an image from a list of images
  void removeImageFromList(int index) {
    _images.removeAt(index);
    notifyListeners();
  }

  void setIsUpdatingImage({required bool value}) {
    _isUpdatingImage = value;
    notifyListeners();
  }

  void resetImage() {
    _image = null;
    notifyListeners();
  }

//Clear everything in the list
  void clearAll() {
    _images.clear();
    notifyListeners();
  }

  //Pick a single image only
  void getImage() async {
    final XFile? pickedFile =
        await _picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _image = File(pickedFile.path);
      notifyListeners();
      //return _image;
    } else {
      getLostDataImage();
    }

    ///return null;
  }

  Future<void> getLostDataImage() async {
    final LostDataResponse response = await _picker.retrieveLostData();
    if (response.isEmpty) {
      return;
    }
    if (response.file != null) {
      _image = File(response.file!.path);
      notifyListeners();
    } else {}
  }
}
