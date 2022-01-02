// ignore_for_file: avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:the_social/screens/Stories/stories_widgets.dart';

class StoriesHelpers with ChangeNotifier {
  late UploadTask imageUploadTask;
  final picker = ImagePicker();
  File? storyImage;
  File? get getStoryImage => storyImage;
  final StoryWigets storyWigets = StoryWigets();
  late String storyImageUrl;
  String get getStoryImageUrl => storyImageUrl;

  Future selectStoryImage(BuildContext context, ImageSource source) async {
    final pickedStoryImage = await picker.pickImage(source: source);
    pickedStoryImage == null
        ? print('error')
        : storyImage = File(pickedStoryImage.path);

    storyImage != null
        ? storyWigets.priviewStoryImage(context, storyImage!)
        : print('error');
    notifyListeners();
  }

  Future uploadStoryImage(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('stories/${getStoryImage!.path}/${Timestamp.now()}');
    imageUploadTask = imageReference.putFile(getStoryImage!);
    await imageUploadTask.whenComplete(() {
      print('-----------------story image uploaded----------------------');
    });
    imageReference.getDownloadURL().then((url) {
      storyImageUrl = url;
      print('-----------------story image url----------------------' +
          storyImageUrl.toString());
    });
    notifyListeners();
  }
}
