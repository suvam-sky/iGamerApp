// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/AltProfile/alt_profile.dart';
import 'package:the_social/screens/Stories/stories.dart';

import 'package:the_social/services/authentication.dart';
import 'package:the_social/utils/post_options.dart';
import 'package:the_social/utils/upload_post.dart';

class FeedHelpers with ChangeNotifier {
  appBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF100E20).withOpacity(0.4),
      centerTitle: true,
      actions: [
        IconButton(
            onPressed: () {
              Provider.of<UploadPost>(context, listen: false)
                  .selectPostImageType(context);
            },
            icon: const Icon(Icons.camera_enhance_rounded))
      ],
      title: RichText(
        text: const TextSpan(
            text: 'Social ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 20.0),
            children: [
              TextSpan(
                  text: 'Feed',
                  style: TextStyle(
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0))
            ]),
      ),
    );
  }

  Widget feedBody(BuildContext context) {
    return SingleChildScrollView(
      physics: const ClampingScrollPhysics(),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('stories')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  PageTransition(
                                      child: Stories(
                                          documentSnapshot: documentSnapshot),
                                      type: PageTransitionType.rightToLeft));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Container(
                                child: Image.network(
                                    documentSnapshot['userimage']),
                                height: 30.0,
                                width: 50.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.blue, width: 2.0)),
                              ),
                            ));
                      }).toList(),
                    );
                  }
                },
              ),
              height: MediaQuery.of(context).size.height * 0.06,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(12.0)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('posts')
                    .orderBy('time', descending: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(
                      child: SizedBox(
                        height: 500.0,
                        width: 400.0,
                        child: Lottie.asset('assets/animations/loading.json'),
                      ),
                    );
                  } else {
                    return loadPost(context, snapshot);
                  }
                },
              ),
              //height: MediaQuery.of(context).size.height * 1.3,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(18.0),
                      topRight: Radius.circular(18.0))),
            ),
          ),
        ],
      ),
    );
  }

  Widget loadPost(BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
    return ListView(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      children: snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
        Provider.of<PostFunctions>(context, listen: false)
            .showTimeAgo(documentSnapshot['time']);

        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.62,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        if (documentSnapshot['useruid'] !=
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid) {
                          Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  child: AltProfile(
                                    userUid: documentSnapshot['useruid'],
                                  ),
                                  type: PageTransitionType.leftToRight));
                        }
                      },
                      // ---- showing user image --------------
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 20.0,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Container(
                        // color: Colors.red,
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              child: Text(
                                documentSnapshot['caption'],
                                style: const TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                            ),
                            SizedBox(
                                child: RichText(
                              text: TextSpan(
                                  text: documentSnapshot['username'],
                                  style: const TextStyle(
                                      color: Colors.green,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16.0),
                                  children: <TextSpan>[
                                    TextSpan(
                                      text:
                                          ' , ${Provider.of<PostFunctions>(context, listen: false).getImageTimePosted.toString()}',
                                      style: TextStyle(
                                        color:
                                            Colors.lightGreen.withOpacity(0.8),
                                      ),
                                    )
                                  ]),
                            )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: SizedBox(
                  height: MediaQuery.of(context).size.height * 0.46,
                  width: MediaQuery.of(context).size.width,
                  child: FittedBox(
                    child: Image.network(
                      documentSnapshot['postimage'],
                      scale: 2,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Padding(
                  padding: const EdgeInsets.only(left: 22),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      SizedBox(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onLongPress: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showLikes(
                                        context, documentSnapshot['caption']);
                              },
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .addLike(
                                        context,
                                        documentSnapshot['caption'],
                                        Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid);
                              },
                              child: const Icon(
                                FontAwesomeIcons.heart,
                                color: Colors.red,
                                size: 22.0,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(documentSnapshot['caption'])
                                    .collection('likes')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showCommentSheet(context, documentSnapshot,
                                        documentSnapshot['caption']);
                              },
                              child: const Icon(
                                FontAwesomeIcons.comment,
                                color: Colors.blue,
                                size: 22.0,
                              ),
                            ),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('posts')
                                    .doc(documentSnapshot['caption'])
                                    .collection('comments')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Text(
                                        snapshot.data!.docs.length.toString(),
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18.0),
                                      ),
                                    );
                                  }
                                })
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 80.0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            GestureDetector(
                              child: const Icon(
                                FontAwesomeIcons.award,
                                color: Colors.yellow,
                                size: 22.0,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(left: 6.0),
                              child: Text(
                                '0',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                            )
                          ],
                        ),
                      ),
                      const Spacer(),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              documentSnapshot['useruid']
                          ? IconButton(
                              onPressed: () {
                                Provider.of<PostFunctions>(context,
                                        listen: false)
                                    .showPostOptions(
                                        context, documentSnapshot['caption']);
                              },
                              icon: const Icon(
                                EvaIcons.moreVertical,
                                color: Colors.white,
                              ))
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            )
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
