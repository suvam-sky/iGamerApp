// ignore_for_file: avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/AltProfile/alt_profile.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class AltProfileHelpers with ChangeNotifier {
  appBar(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
        ),
        onPressed: () {
          Navigator.pushReplacement(
              context,
              PageTransition(
                  child: const HomePage(),
                  type: PageTransitionType.leftToRight));
        },
      ),
      backgroundColor: Colors.blueGrey,
      centerTitle: true,
      actions: [
        IconButton(
          icon: const Icon(
            EvaIcons.moreVertical,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.leftToRight));
          },
        ),
      ],
      title: RichText(
        text: const TextSpan(
            text: 'The ',
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16.0),
            children: <TextSpan>[
              TextSpan(
                text: 'Social',
                style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0),
              )
            ]),
      ),
    );
  }

  Widget headerprofile(BuildContext context,
      AsyncSnapshot<DocumentSnapshot> snapshot, String userUid) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.37,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                height: 200.0,
                width: 180.0,
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: () {},
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 60.0,
                        backgroundImage: NetworkImage(snapshot.data![
                            'userimage']), //snapshot.data()!['userimage']
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        snapshot.data!['username'],
                        style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20.0),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            EvaIcons.email,
                            color: Colors.green,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Text(
                              snapshot.data!['useremail'],
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          GestureDetector(
                            //---------------- see followers------------
                            onTap: () {
                              checkFollowersSheet(context, snapshot);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.green,
                                  borderRadius: BorderRadius.circular(15.0)),
                              height: 70.0,
                              width: 80.0,
                              child: Column(
                                children: [
                                  // ------------followers count------------
                                  StreamBuilder<QuerySnapshot>(
                                      stream: FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(snapshot.data!['useruid'])
                                          .collection('followers')
                                          .snapshots(),
                                      builder: (context, snapshot) {
                                        if (snapshot.connectionState ==
                                            ConnectionState.waiting) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        } else {
                                          return Text(
                                            snapshot.data!.docs.length
                                                .toString(),
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 28.0),
                                          );
                                        }
                                      }),
                                  const Text(
                                    'Followers',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12.0),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // ------------following count------------
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.deepOrange,
                                borderRadius: BorderRadius.circular(15.0)),
                            height: 70.0,
                            width: 80.0,
                            child: Column(
                              children: [
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .doc(snapshot.data!['useruid'])
                                        .collection('following')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      if (snapshot.connectionState ==
                                          ConnectionState.waiting) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      } else {
                                        return Text(
                                          snapshot.data!.docs.length.toString(),
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 28.0),
                                        );
                                      }
                                    }),
                                const Text(
                                  'Following',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12.0),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepOrange,
                            borderRadius: BorderRadius.circular(15.0)),
                        height: 70.0,
                        width: 80.0,
                        child: Column(
                          children: [
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(snapshot.data!['useruid'])
                                    .collection('posts')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else {
                                    return Text(
                                      snapshot.data!.docs.length.toString(),
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 28.0),
                                    );
                                  }
                                }),
                            // Text(
                            //   '0',
                            //   style: TextStyle(
                            //       color: Colors.white,
                            //       fontWeight: FontWeight.bold,
                            //       fontSize: 28.0),
                            // ),
                            const Text(
                              'Posts',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                MaterialButton(
                  onPressed: () {
                    //print('.............pressing follow button..............');
                    Provider.of<FirebaseOperations>(context, listen: false)
                        .followUser(
                            userUid, //1st
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid, //2nd
                            {
                              //3rd
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                              'time': Timestamp.now()
                            },
                            Provider.of<Authentication>(context, listen: false)
                                .getUserUid, //4th
                            userUid, //5th
                            {
                              //6th
                              'username': snapshot.data!['username'],
                              'userimage': snapshot.data!['userimage'],
                              'useremail': snapshot.data!['useremail'],
                              'useruid': snapshot.data!['useruid'],
                              'time': Timestamp.now()
                            })
                        .whenComplete(() {
                      print(
                          '.............pressing complete button..............');
                      followedNotification(
                          context, snapshot.data!['userimage']);
                    });
                  },
                  color: Colors.blue,
                  child: const Text(
                    'Follow',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                MaterialButton(
                  onPressed: () {
                    print("-------useruid--------" + userUid);
                    print("-------name--------" + snapshot.data!['username']);
                    print("-------image--------" + snapshot.data!['userimage']);
                    print("-------email--------" + snapshot.data!['useremail']);
                    print("---------useruid------" + snapshot.data!['useruid']);
                  },
                  color: Colors.blue,
                  child: const Text(
                    'Message',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget divider() {
    return const Center(
      child: SizedBox(
        height: 25,
        width: 350,
        child: Divider(
          color: Colors.white,
        ),
      ),
    );
  }

  Widget middleProfile(BuildContext context, dynamic snapshot) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 150.0,
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(2.0)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Icon(
                FontAwesomeIcons.userAstronaut,
                color: Colors.yellow,
                size: 16,
              ),
              Text(
                'Recently Added',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.0,
                    color: Colors.white),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color(0xFF100E20).withOpacity(0.4),
                borderRadius: BorderRadius.circular(2.0)),
          ),
        )
      ],
    );
  }

  Widget footerProfile(BuildContext context, dynamic snapshot) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            //color: const Color(0xFF100E20).withOpacity(0.6),
            borderRadius: BorderRadius.circular(5.0)),
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('users')
              .doc(snapshot.data['useruid'])
              .collection('posts')
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return GridView(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                  ),
                  children:
                      snapshot.data!.docs.map((DocumentSnapshot snapshot) {
                    return SizedBox(
                      height: MediaQuery.of(context).size.height * 0.5,
                      width: MediaQuery.of(context).size.width,
                      child: FittedBox(
                        child: Image.network(snapshot['postimage']),
                      ),
                    );
                  }).toList());
            }
          },
        ),
      ),
    );
  }

  followedNotification(BuildContext context, String name) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  Text(
                    'Followed $name',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: const Color(0xFF100E20).withOpacity(0.4),
                  borderRadius: BorderRadius.circular(12.0)));
        });
  }

  checkFollowersSheet(BuildContext context, dynamic snapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              height: MediaQuery.of(context).size.height * 0.4,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: const Color(0xFF100E20),
                  borderRadius: BorderRadius.circular(2.0)),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot.data['useruid'])
                    .collection('followers')
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
                        onTap: () {
                          if (documentSnapshot['useruid'] !=
                              Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid) {
                            Navigator.push(
                                context,
                                PageTransition(
                                    child: AltProfile(
                                        userUid: documentSnapshot['useruid']),
                                    type: PageTransitionType.leftToRight));
                          }
                        },
                        leading: CircleAvatar(
                          backgroundColor: Colors.blue,
                          backgroundImage:
                              NetworkImage(documentSnapshot['userimage']),
                        ),
                        title: Text(
                          documentSnapshot[
                              'username'], //documentSnapshot.data()!['useremail']
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                              fontSize: 16.0),
                        ),
                        subtitle: Text(
                          documentSnapshot[
                              'useremail'], //documentSnapshot.data()!['useremail']
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.yellow,
                              fontSize: 12.0),
                        ),
                        trailing: documentSnapshot['useruid'] ==
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid
                            ? const SizedBox(
                                height: 0,
                                width: 0,
                              )
                            : MaterialButton(
                                onPressed: () {},
                                color: Colors.blue,
                                child: const Text(
                                  'Unfollow',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontSize: 16.0),
                                ),
                              ),
                      );
                    }).toList());
                  }
                },
              ));
        });
  }
}
