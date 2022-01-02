// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/landingPage/landing_utils.dart';
import 'package:the_social/services/authentication.dart';

class FirebaseOperations with ChangeNotifier {
  late UploadTask imageUploadTask;
  late String initUserName, initUsereEmail, initUserImage;
  late String hello;

  String get getInitUserName => initUserName;
  String get getInitUserEmail => initUsereEmail;
  String get getInitUserImage => initUserImage;

  Future uploadUserAvater(BuildContext context) async {
    Reference imageReference = FirebaseStorage.instance.ref().child(
        'userProfileImage/${Provider.of<LandingUtils>(context, listen: false).getUserAvater!.path}/${TimeOfDay.now()}}');

    imageUploadTask = imageReference.putFile(
        Provider.of<LandingUtils>(context, listen: false).getUserAvater!);
    await imageUploadTask.whenComplete(() {
      print('Image Uploaded');
    });
    imageReference.getDownloadURL().then((url) {
      Provider.of<LandingUtils>(context, listen: false).userAvaterUrl =
          url.toString();

      print("profile pic uploaded.............................");
      notifyListeners();
    });
  }

  Future createUserCollevctions(BuildContext context, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .set(data);
  }

  Future initUserData(BuildContext context) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(Provider.of<Authentication>(context, listen: false).getUserUid)
        .get()
        .then((doc) {
      print('.................fetching user data..................');
      initUserName = doc.data()!['username'];
      initUsereEmail = doc.data()!['useremail'];
      initUserImage = doc.data()!['userimage'];
      // print(initUserName + " ......................................");
      print(initUserImage + " ................userimage......................");
      notifyListeners();
    });
  }

  Future uploadPostData(String postId, dynamic data) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).set(data);
  }

  Future deleteUserData(String userUid) async {
    return FirebaseFirestore.instance.collection('users').doc(userUid).delete();
  }

  Future deletePost(String postId) async {
    return FirebaseFirestore.instance.collection('posts').doc(postId).delete();
  }

  Future updatePost(String postId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .update(data);
  }

  Future ownFeed(userId, dynamic data) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('posts')
        .add(data);
  }

  Future followUser(
      String followingUid,
      String followingDocid,
      dynamic followingData,
      String followerUid,
      String followerDocId,
      dynamic followerData) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(followingUid)
        .collection('followers')
        .doc(followingDocid)
        .set(followingData)
        .whenComplete(() async {
      return FirebaseFirestore.instance
          .collection('users')
          .doc(followerUid)
          .collection('following')
          .doc(followerDocId)
          .set(followerData);
    });
  }

  Future submitChatroomData(String chatRoomName, dynamic chatRoomData) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .set(chatRoomData);
  }
}
