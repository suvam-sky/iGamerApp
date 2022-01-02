// ignore_for_file: sized_box_for_whitespace, avoid_print

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/screens/Stories/stories_helpers.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class StoryWigets {
  addStory(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
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
                      onPressed: () {
                        Provider.of<StoriesHelpers>(context, listen: false)
                            .selectStoryImage(context, ImageSource.gallery)
                            .whenComplete(() {
                          //Navigator.pop(context);
                        });
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
                      onPressed: () {
                        Provider.of<StoriesHelpers>(context, listen: false)
                            .selectStoryImage(context, ImageSource.camera)
                            .whenComplete(() {
                          // Navigator.pop(context);
                        });
                      },
                      child: const Text(
                        'Camera',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16.0),
                      ),
                    )
                  ],
                )
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
          );
        });
  }

  priviewStoryImage(BuildContext context, File storyImage) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12.0)),
            child: Stack(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(storyImage),
                ),
                Positioned(
                    top: 600,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FloatingActionButton(
                            onPressed: () {
                              addStory(context);
                            },
                            heroTag: 'Reselect image',
                            backgroundColor: Colors.red,
                            child: const Icon(
                              FontAwesomeIcons.backspace,
                              color: Colors.white,
                            ),
                          ),
                          FloatingActionButton(
                            onPressed: () {
                              Provider.of<StoriesHelpers>(context,
                                      listen: false)
                                  .uploadStoryImage(context)
                                  .whenComplete(() async {
                                try {
                                  await FirebaseFirestore.instance
                                      .collection('stories')
                                      .doc(Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid)
                                      .set({
                                    'image': Provider.of<StoriesHelpers>(
                                            context,
                                            listen: false)
                                        .storyImageUrl,
                                    'username': Provider.of<FirebaseOperations>(
                                            context,
                                            listen: false)
                                        .getInitUserName,
                                    'userimage':
                                        Provider.of<FirebaseOperations>(context,
                                                listen: false)
                                            .getInitUserImage,
                                    'useruid': Provider.of<Authentication>(
                                            context,
                                            listen: false)
                                        .getUserUid,
                                    'time': Timestamp.now()
                                  }).whenComplete(() {
                                    Navigator.pushReplacement(
                                        context,
                                        PageTransition(
                                            child: const HomePage(),
                                            type: PageTransitionType
                                                .leftToRight));
                                  });
                                } catch (e) {
                                  print(e.toString());
                                }
                              });
                            },
                            heroTag: 'Confirm image',
                            backgroundColor: Colors.red,
                            child: const Icon(
                              FontAwesomeIcons.check,
                              color: Colors.blue,
                            ),
                          ),
                        ],
                      ),
                    ))
              ],
            ),
          );
        });
  }

  addToHighlights(BuildContext context, String storyImage) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                const Text(
                  'Add to Existing Album',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                  color: Colors.red,
                ),
                const Text(
                  'Create New Album',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14.0),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  width: MediaQuery.of(context).size.width,
                ),
              ],
            ),
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12.0)),
          );
        });
  }
}
