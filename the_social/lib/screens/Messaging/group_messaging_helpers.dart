// ignore_for_file: sized_box_for_whitespace

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:timeago/timeago.dart' as timeago;

class GroupMessagingHlepers with ChangeNotifier {
  bool hasMemberJoined = false;
  String? lastMessageTime;
  String? get getLastMessageTime => lastMessageTime;
  bool get getHasMemberJoined => hasMemberJoined;

  sendMessage(BuildContext context, DocumentSnapshot documentSnapshot,
      TextEditingController messageController) {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(documentSnapshot.id)
        .collection('messages')
        .add({
      'message': messageController.text,
      'time': Timestamp.now(),
      'useruid': Provider.of<Authentication>(context, listen: false).getUserUid,
      'userimage': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserImage,
      'username': Provider.of<FirebaseOperations>(context, listen: false)
          .getInitUserName
    });
  }

  showMessages(BuildContext context, DocumentSnapshot documentSnapshot,
      String adminUserUid) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('chatrooms')
            .doc(documentSnapshot.id)
            .collection('messages')
            .orderBy('time', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            return ListView(
              reverse: true,
              children:
                  snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
                showLastMessageTime(documentSnapshot['time']);
                return Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height * 0.125,
                    //color: Colors.red,
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 60.0, top: 20),
                          child: Row(
                            children: [
                              Container(
                                constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8,
                                  maxHeight:
                                      MediaQuery.of(context).size.height * 0.1,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 14.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 150.0,
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                documentSnapshot['username'],
                                                style: const TextStyle(
                                                    color: Colors.yellow,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14.0),
                                              ),
                                            ),
                                            Provider.of<Authentication>(context,
                                                            listen: false)
                                                        .getUserUid ==
                                                    adminUserUid
                                                ? const Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Icon(
                                                      FontAwesomeIcons
                                                          .chessKing,
                                                      color: Colors.yellow,
                                                      size: 12.0,
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    width: 0,
                                                    height: 0,
                                                  )
                                          ],
                                        ),
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          documentSnapshot['message'],
                                          style: const TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16.0),
                                        ),
                                      ),
                                      Container(
                                        width: 80.0,
                                        child: Text(getLastMessageTime!,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 8.0)),
                                      )
                                    ],
                                  ),
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8.0),
                                    color: Provider.of<Authentication>(context,
                                                    listen: false)
                                                .getUserUid ==
                                            documentSnapshot['useruid']
                                        ? Colors.blueGrey
                                        : Colors.green),
                              )
                            ],
                          ),
                        ),
                        Positioned(
                            // top: 12,
                            left: 10.0,
                            child: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot['useruid']
                                ? Container(
                                    child: Column(
                                      children: [
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              Icons.edit,
                                              color: Colors.blue,
                                              size: 14,
                                            )),
                                        IconButton(
                                            onPressed: () {},
                                            icon: const Icon(
                                              FontAwesomeIcons.trash,
                                              color: Colors.red,
                                              size: 14,
                                            )),
                                      ],
                                    ),
                                  )
                                : const SizedBox(
                                    width: 0,
                                    height: 0,
                                  )),
                        Positioned(
                            left: 40,
                            child: Provider.of<Authentication>(context,
                                            listen: false)
                                        .getUserUid ==
                                    documentSnapshot['useruid']
                                ? const SizedBox(
                                    width: 0,
                                    height: 0,
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.black,
                                    backgroundImage: NetworkImage(
                                        documentSnapshot['userimage']),
                                  ))
                      ],
                    ),
                  ),
                );
              }).toList(),
            );
          }
        });
  }

  Future checkIfJoined(BuildContext context, String chatRoomName,
      String chatRoomAdminUid) async {
    return FirebaseFirestore.instance
        .collection('chatrooms')
        .doc(chatRoomName)
        .collection('members')
        .doc(
          Provider.of<Authentication>(context, listen: false).getUserUid,
        )
        .get()
        .then((value) {
      hasMemberJoined = false;
      if (value['joined'] != null) {
        hasMemberJoined = value['joined'];
        notifyListeners();
      }
      if (Provider.of<Authentication>(context, listen: false).getUserUid ==
          chatRoomAdminUid) {
        hasMemberJoined = true;
        notifyListeners();
      }
    });
  }

  asktoJoin(BuildContext context, String roomName) {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(
              'Join $roomName ?',
              style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 16.0),
            ),
            actions: [
              MaterialButton(
                onPressed: () {
                  Navigator.pushReplacement(
                      context,
                      PageTransition(
                          child: const HomePage(),
                          type: PageTransitionType.leftToRight));
                },
                child: const Text(
                  'No',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              ),
              MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  FirebaseFirestore.instance
                      .collection('chatrooms')
                      .doc(roomName)
                      .collection('members')
                      .doc(Provider.of<Authentication>(context, listen: false)
                          .getUserUid)
                      .set({
                    'joined': true,
                    'username':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserName,
                    'userimage':
                        Provider.of<FirebaseOperations>(context, listen: false)
                            .getInitUserImage,
                    'useruid':
                        Provider.of<Authentication>(context, listen: false)
                            .getUserUid,
                    'time': Timestamp.now()
                  }).whenComplete(() {
                    Navigator.pop(context);
                  });
                },
                child: const Text(
                  'Yes',
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0),
                ),
              )
            ],
          );
        });
  }

  showLastMessageTime(dynamic timeData) {
    Timestamp time = timeData;
    DateTime dateTime = time.toDate();
    lastMessageTime = timeago.format(dateTime);
    notifyListeners();
  }
}
