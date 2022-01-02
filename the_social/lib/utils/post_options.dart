// ignore_for_file: avoid_unnecessary_containers, sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/AltProfile/alt_profile.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class PostFunctions with ChangeNotifier {
  TextEditingController commentController = TextEditingController();
  TextEditingController updatedCaptionController = TextEditingController();
  String? imagetimeposted;
  String? get getImageTimePosted => imagetimeposted;

  Future addLike(BuildContext context, String postId, String subDocId) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('likes')
        .doc(subDocId)
        .set({
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  Future addComment(BuildContext context, String postId, String comment) async {
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .collection('comments')
        .doc(comment)
        .set({
      'comment': comment,
      'likes': FieldValue.increment(1),
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName,
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'useremail': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserEmail,
      'time': Timestamp.now()
    });
  }

  showCommentSheet(
      BuildContext context, DocumentSnapshot snapshot, String docId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  Container(
                    width: 100.0,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(color: Colors.white)),
                    child: const Center(
                      child: Text(
                        'Comments',
                        style: TextStyle(
                            color: Colors.blue,
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  // ------ show comments --------------
                  Container(
                    height: MediaQuery.of(context).size.height * 0.45,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('posts')
                          .doc(docId)
                          .collection('comments')
                          .orderBy('time')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Container(
                                height:
                                    MediaQuery.of(context).size.height * 0.15,
                                width: MediaQuery.of(context).size.width,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: GestureDetector(
                                            onTap: () {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: AltProfile(
                                                          userUid:
                                                              documentSnapshot[
                                                                  'useruid']),
                                                      type: PageTransitionType
                                                          .leftToRight));
                                            },
                                            child: CircleAvatar(
                                              backgroundColor: Colors.blueGrey,
                                              radius: 15.0,
                                              backgroundImage: NetworkImage(
                                                  documentSnapshot[
                                                      'userimage']),
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 8.0),
                                          child: Container(
                                            child: Text(
                                              documentSnapshot['username'],
                                              style: const TextStyle(
                                                  color: Colors.blue,
                                                  fontSize: 18.0,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                onPressed: () {},
                                                icon: const Icon(
                                                  FontAwesomeIcons.arrowUp,
                                                  color: Colors.blue,
                                                  size: 12,
                                                ),
                                              ),
                                              const Text('0',
                                                  style: TextStyle(
                                                      color: Colors.blue,
                                                      fontSize: 14.0,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              IconButton(
                                                  onPressed: () {},
                                                  icon: const Icon(
                                                    FontAwesomeIcons.reply,
                                                    color: Colors.yellow,
                                                    size: 12,
                                                  )),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      child: Row(
                                        children: [
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                Icons
                                                    .arrow_forward_ios_outlined,
                                                color: Colors.blue,
                                                size: 15.0,
                                              )),

                                          SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.75,
                                            child: Text(
                                                documentSnapshot['comment'],
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16.0,
                                                )),
                                          ),
                                          IconButton(
                                              onPressed: () {},
                                              icon: const Icon(
                                                FontAwesomeIcons.trash,
                                                color: Colors.red,
                                                size: 16,
                                              )),
                                          // const Divider(
                                          //   color: Colors.deepOrange,
                                          // )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),

                  //------- Add comment -----------
                  Container(
                    //width: MediaQuery.of(context).size.width,
                    width: 500.0,
                    //color: Colors.red,
                    height: 50.0,

                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          width: 300.0,
                          height: 20.0,
                          child: TextField(
                              textCapitalization: TextCapitalization.sentences,
                              decoration: const InputDecoration(
                                  hintText: 'Add comment...',
                                  helperStyle: TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold)),
                              controller: commentController,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 16.0,
                                  fontWeight: FontWeight.bold)),
                        ),
                        FloatingActionButton(
                          onPressed: () {
                            addComment(context, snapshot['caption'],
                                    commentController.text)
                                .whenComplete(() {
                              commentController.clear();
                              notifyListeners();
                            });
                          },
                          child: const Icon(
                            FontAwesomeIcons.comment,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          );
        });
  }

  showLikes(BuildContext context, String postId) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.50,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                )),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Container(
                  width: 100.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5.0),
                      border: Border.all(color: Colors.white)),
                  child: const Center(
                    child: Text(
                      'Likes',
                      style: TextStyle(
                          color: Colors.blue,
                          fontSize: 16.0,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Container(
                  height: MediaQuery.of(context).size.height * 0.20,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('posts')
                        .doc(postId)
                        .collection('likes')
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else {
                        return ListView(
                          children: snapshot.data!.docs
                              .map((DocumentSnapshot documentSnapshot) {
                            return ListTile(
                              leading: GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: AltProfile(
                                              userUid:
                                                  documentSnapshot['useruid']),
                                          type:
                                              PageTransitionType.leftToRight));
                                },
                                child: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      documentSnapshot['userimage']),
                                ),
                              ),
                              title: Text(
                                documentSnapshot['username'],
                                style: const TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              subtitle: Text(
                                documentSnapshot['useremail'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              trailing: Provider.of<Authentication>(context,
                                              listen: false)
                                          .getUserUid ==
                                      documentSnapshot['useruid']
                                  ? const SizedBox(
                                      width: 0,
                                      height: 0,
                                    )
                                  : MaterialButton(
                                      child: const Text(
                                        'Follow',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0),
                                      ),
                                      color: Colors.blue,
                                      onPressed: () {},
                                    ),
                            );
                          }).toList(),
                        );
                      }
                    },
                  ),
                )
              ],
            ),
          );
        });
  }

  showTimeAgo(dynamic timedata) {
    Timestamp time = timedata;
    DateTime dateTime = time.toDate();
    imagetimeposted = timeago.format(dateTime);
    notifyListeners();
  }

  showPostOptions(BuildContext context, String postId) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.10,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                  )),
              child: Column(children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                      MaterialButton(
                          color: Colors.blue,
                          child: const Text(
                            'Edit caption',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          onPressed: () {
                            showModalBottomSheet(
                                context: context,
                                builder: (context) {
                                  return Container(
                                    color: Colors.orangeAccent,
                                    child: Center(
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 300.0,
                                            height: 50,
                                            child: TextField(
                                              decoration: const InputDecoration(
                                                  hintText:
                                                      'Add new caption . . ',
                                                  hintStyle: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold)),
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold),
                                              controller:
                                                  updatedCaptionController,
                                            ),
                                          ),
                                          FloatingActionButton(
                                              backgroundColor: Colors.blue,
                                              child: const Icon(
                                                FontAwesomeIcons.fileUpload,
                                                color: Colors.white,
                                              ),
                                              onPressed: () {
                                                Provider.of<FirebaseOperations>(
                                                        context,
                                                        listen: false)
                                                    .updatePost(postId, {
                                                  'caption':
                                                      updatedCaptionController
                                                          .text
                                                });
                                              })
                                        ],
                                      ),
                                    ),
                                  );
                                });
                          }),
                      MaterialButton(
                          color: Colors.red,
                          child: const Text(
                            'Delete Post',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                          ),
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: const Text('Delete this Post ?',
                                        style: TextStyle(
                                            color: Colors.red,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0)),
                                    actions: [
                                      MaterialButton(
                                          color: Colors.blue,
                                          child: const Text(
                                            'No',
                                            style: TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor: Colors.white,
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                          onPressed: () {
                                            Navigator.pop(context);
                                          }),
                                      MaterialButton(
                                          color: Colors.blue,
                                          child: const Text(
                                            'Yes',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16.0),
                                          ),
                                          onPressed: () {
                                            Provider.of<FirebaseOperations>(
                                                    context,
                                                    listen: false)
                                                .deletePost(postId)
                                                .whenComplete(() {
                                              Navigator.pop(context);
                                            });
                                          })
                                    ],
                                  );
                                });
                          })
                    ]))
              ]),
            ),
          );
        });
  }
}
