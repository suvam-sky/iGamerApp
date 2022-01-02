// ignore_for_file: sized_box_for_whitespace, avoid_unnecessary_containers

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:lottie/lottie.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/AltProfile/alt_profile.dart';
import 'package:the_social/screens/Messaging/group_messaging.dart';
import 'package:the_social/screens/Messaging/group_messaging_helpers.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class ChatroomHelpers with ChangeNotifier {
  String? chatroomAvatarUrl, chatroomID, lastestMessageTime;
  String? get getChatroomAvatarUrl => chatroomAvatarUrl;
  String? get getChatroomID => chatroomID;
  String? get getLastestMessageTime => lastestMessageTime;
  bool x = false;
  bool get getxx => x;

  final TextEditingController chatroomNameController = TextEditingController();
  final TextEditingController noMessage = TextEditingController();
  showCreateChatroomSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  const Text(
                    'Select Chatroom Avatar',
                    style: TextStyle(
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                        fontSize: 14.0),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.1,
                    width: MediaQuery.of(context).size.width,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatroomIcons')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
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
                                  notifyListeners();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 16.0),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border:
                                            Border.all(color: Colors.black)),
                                    height: 10.0,
                                    width: 40.0,
                                    child: Image.network(
                                        documentSnapshot['image']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: TextField(
                            textCapitalization: TextCapitalization.words,
                            controller: chatroomNameController,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            decoration: const InputDecoration(
                              hintText: 'Enter chatroom ID',
                              hintStyle: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          )),
                      FloatingActionButton(
                          backgroundColor: Colors.blueGrey,
                          child: const Icon(
                            FontAwesomeIcons.plus,
                            color: Colors.yellow,
                          ),
                          onPressed: () async {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .submitChatroomData(
                                    chatroomNameController.text, {
                              'time': Timestamp.now(),
                              'roomname': chatroomNameController.text,
                              'username': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserName,
                              'useremail': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserEmail,
                              'userimage': Provider.of<FirebaseOperations>(
                                      context,
                                      listen: false)
                                  .getInitUserImage,
                              'useruid': Provider.of<Authentication>(context,
                                      listen: false)
                                  .getUserUid,
                            });
                            // Provider.of<GroupMessagingHlepers>(context,
                            //         listen: false)
                            //     .sendMessage(context, ,
                            //         noMessage);
                          })
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12.0),
                      topRight: Radius.circular(12.0)),
                  color: Colors.blueGrey),
            ),
          );
        });
  }

  showChatRooms(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('chatrooms').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: SizedBox(
                height: 200.0,
                width: 200.0,
                child: Lottie.asset('assets/animations/loading.json'),
              ),
            );
          } else {
            return ListView(
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                //print(documentSnapshot.id);
                // var userDocref = FirebaseFirestore.instance
                //     .collection('chatrooms')
                //     .doc(documentSnapshot.id)
                //     ;
                // var doc = userDocref.get().then((value) {
                //   if (value.get('time') == null) {
                //     x = true;
                //   }
                // });
                // var qs = FirebaseFirestore.instance
                //     .collection('chatrooms')
                //     .doc(documentSnapshot.id);
                // print(qs.get().then((value) {
                //   print(value.get('messages'));
                //   if (value.get('messages') == Future<void>) {
                //     print("not exists");
                //   }
                // }));
                FirebaseFirestore.instance
                    .collection('chatrooms')
                    .doc(documentSnapshot.id)
                    .collection('messages')
                    .get()
                    .then((doc) => {
                          //print(doc.docs.length),
                          if (doc.docs.isEmpty)
                            {
                              x = true,
                              //print("not exisst")
                            }
                        });
                print(
                    "---------------------------------------hghghggvgvgvh----------------------");

                return ListTile(
                  onTap: () {
                    Navigator.pushReplacement(
                        context,
                        PageTransition(
                            child: GroupMessage(
                                documentSnapshot: documentSnapshot),
                            type: PageTransitionType.leftToRight));
                  },
                  onLongPress: () {
                    showChatroomDetails(context, documentSnapshot);
                  },
                  leading: const CircleAvatar(
                    backgroundColor: Colors.red,
                  ),
                  title: Text(
                    documentSnapshot['roomname'],
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 16.0),
                  ),
                  subtitle: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('chatrooms')
                        .doc(documentSnapshot.id)
                        .collection('messages')
                        .orderBy('time', descending: true)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (snapshot.data!.docs.first['username'] !=
                          null) {
                        return Text(
                          '${snapshot.data!.docs.first['username']} : ${snapshot.data!.docs.first['message']}',
                          style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0),
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        print(snapshot.data!);
                        print(
                            "---------------------------------------inside----------------------");
                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } else if (snapshot.data!.docs.isEmpty) {
                        return Container(
                          width: 0,
                          height: 0,
                        );
                      } else {
                        return Container(
                          width: 0,
                          height: 0,
                        );
                      }
                    },
                  )
                  // : Container(
                  //     height: 0,
                  //     width: 0,
                  //   ),
                  ,
                  trailing: Container(
                    width: 0.0,
                    child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentSnapshot.id)
                          .collection('messages')
                          .orderBy('time', descending: true)
                          .snapshots(),
                      builder: (context, snapshot) {
                        //showLastMessageTime(snapshot.data!.docs.first['time']);
                        // print("--------------" +
                        //     snapshot.data!.docs.first['time']);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                              child: CircularProgressIndicator());
                        } else {
                          return const Text("2",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12.0));
                        }
                      },
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  showChatroomDetails(BuildContext context, DocumentSnapshot documentSnapshot) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.27,
            width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12.0),
                    topRight: Radius.circular(12.0))),
            child: Column(
              children: [
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.blue,
                      ),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(8.0),
                    child: Text(
                      'Members',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                  ),
                ),
                Container(
                  //color: Colors.red,
                  child: StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('chatrooms')
                          .doc(documentSnapshot.id)
                          .collection('members')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        } else {
                          return ListView(
                            scrollDirection: Axis.horizontal,
                            children: snapshot.data!.docs
                                .map((DocumentSnapshot documentSnapshot) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: GestureDetector(
                                  onTap: () {
                                    if (Provider.of<Authentication>(context,
                                                listen: false)
                                            .getUserUid !=
                                        documentSnapshot['useruid']) {
                                      Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                              child: AltProfile(
                                                  userUid: documentSnapshot[
                                                      'useruid']),
                                              type: PageTransitionType
                                                  .leftToRight));
                                    }
                                  },
                                  child: CircleAvatar(
                                    radius: 25.0,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ),
                                ),
                              );
                            }).toList(),
                          );
                        }
                      }),
                  height: MediaQuery.of(context).size.height * 0.06,
                  width: MediaQuery.of(context).size.width,
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(12)),
                  child: const Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Text(
                      'Admin',
                      style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.0),
                    ),
                  ),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.transparent,
                        backgroundImage:
                            NetworkImage(documentSnapshot['userimage']),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(
                          documentSnapshot['username'],
                          style: const TextStyle(
                              color: Colors.green,
                              fontWeight: FontWeight.bold,
                              fontSize: 14.0),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          );
        });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp t = timeData;
    DateTime dateTime = t.toDate();
    lastestMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
