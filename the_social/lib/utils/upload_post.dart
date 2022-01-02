// ignore_for_file: avoid_print, avoid_unnecessary_containers, deprecated_member_use

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class UploadPost with ChangeNotifier {
  File? uploadPostImage;
  File? get getUploadPostImage => uploadPostImage;
  String? uploadPostImageUrl;
  String? get getUploadPostImageUrl => uploadPostImageUrl;
  final picker = ImagePicker();
  UploadTask? imagePostUploadTask;
  TextEditingController captionController = TextEditingController();

  Future pickUploadPostImage(BuildContext context, ImageSource source) async {
    final uploadPostImageVal = await picker.pickImage(source: source);
    uploadPostImageVal == null
        ? print("select image ")
        : uploadPostImage = File(uploadPostImageVal.path);
    print("the pic path is =====>  " + uploadPostImageVal!.path);
    print("the pic path .... =====>  " + uploadPostImageVal.toString());

    uploadPostImage != null
        ? showPostImage(context)
        : print(".....................upload error.......................");
    notifyListeners();
  }

  selectPostImageType(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.gallery);
                      },
                      child: const Text(
                        'Gallery',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                    MaterialButton(
                      color: Colors.blue,
                      onPressed: () {
                        pickUploadPostImage(context, ImageSource.camera);
                      },
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    ),
                  ],
                )
              ],
            ),
          );
        });
  }

  showPostImage(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.40,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(12)),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Padding(
                  padding:
                      const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
                  child: SizedBox(
                    height: 200,
                    width: 400,
                    child: Image.file(
                      uploadPostImage!,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                          child: const Text(
                            'Reselect',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                          ),
                          onPressed: () {
                            selectPostImageType(context);
                          }),
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text(
                            'Confirm image',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            uploadPostImageToFirebase().whenComplete(() {
                              editPostSheet(context);
                              print(
                                  '.........image uploded....................');
                            });
                          }),
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  Future uploadPostImageToFirebase() async {
    Reference imageReference = FirebaseStorage.instance
        .ref()
        .child('posts/${uploadPostImage!.path}/${TimeOfDay.now()}');
    imagePostUploadTask = imageReference.putFile(uploadPostImage!);
    await imagePostUploadTask!.whenComplete(() {
      print("hello");
    });
    imageReference.getDownloadURL().then((imageUrl) {
      uploadPostImageUrl = imageUrl;
    });
    notifyListeners();
  }

  editPostSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.75,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Column(
                          children: [
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.aspect_ratio,
                                  color: Colors.green,
                                )),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(
                                  Icons.fit_screen,
                                  color: Colors.yellow,
                                )),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 200.0,
                        width: 300.0,
                        child: Image.file(
                          uploadPostImage!,
                          fit: BoxFit.contain,
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: Image.asset('assets/icons/sunflower.png'),
                      ),
                      Container(
                        height: 110.0,
                        width: 5.0,
                        color: Colors.blue,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 120.0,
                          width: 330.0,
                          child: TextField(
                            controller: captionController,
                            maxLines: 5,
                            textCapitalization: TextCapitalization.words,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(50)
                            ],
                            maxLengthEnforced: true,
                            maxLength: 100,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold),
                            decoration: const InputDecoration(
                              hintText: 'Add a caption...',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                MaterialButton(
                  onPressed: () async {
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .uploadPostData(captionController.text, {
                      'postimage': getUploadPostImageUrl,
                      'caption': captionController.text,
                      'username': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserName,
                      'userimage': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserImage,
                      'useruid':
                          Provider.of<Authentication>(context, listen: false)
                              .getUserUid,
                      'useremail': Provider.of<FirebaseOperations>(context,
                              listen: false)
                          .getInitUserEmail,
                      'time': Timestamp.now()
                    }).whenComplete(() {
                      Provider.of<FirebaseOperations>(context, listen: false)
                          .ownFeed(
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              {
                            'postimage': getUploadPostImageUrl,
                            'caption': captionController.text,
                            'username': Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .getInitUserName,
                            'userimage': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInitUserImage,
                            'useruid': Provider.of<Authentication>(context,
                                    listen: false)
                                .getUserUid,
                            'useremail': Provider.of<FirebaseOperations>(
                                    context,
                                    listen: false)
                                .getInitUserEmail,
                            'time': Timestamp.now()
                          });
                    }).whenComplete(() {
                      Navigator.pop(context);
                    });
                  },
                  child: const Text(
                    'Share',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold),
                  ),
                  color: Colors.blue,
                )
              ],
            ),
          );
        });
  }
}
