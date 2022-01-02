// ignore_for_file: avoid_unnecessary_containers

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/screens/Messaging/group_messaging_helpers.dart';
import 'package:the_social/services/authentication.dart';

class GroupMessage extends StatefulWidget {
  final DocumentSnapshot? documentSnapshot;
  GroupMessage({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  State<GroupMessage> createState() => _GroupMessageState();
}

class _GroupMessageState extends State<GroupMessage> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    Provider.of<GroupMessagingHlepers>(context, listen: false)
        .checkIfJoined(context, widget.documentSnapshot!.id,
            widget.documentSnapshot!['useruid'])
        .whenComplete(() async {
      if (Provider.of<GroupMessagingHlepers>(context, listen: false)
              .getHasMemberJoined ==
          false) {
        Timer(
            const Duration(milliseconds: 10),
            () => Provider.of<GroupMessagingHlepers>(context, listen: false)
                .asktoJoin(context, widget.documentSnapshot!.id));
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          Provider.of<Authentication>(context, listen: false).getUserUid ==
                  widget.documentSnapshot!['useruid']
              ? IconButton(
                  onPressed: () {},
                  icon: const Icon(
                    EvaIcons.moreVertical,
                    color: Colors.white,
                  ))
              : const SizedBox(
                  width: 0,
                  height: 0,
                ),
          IconButton(
              onPressed: () {},
              icon: const Icon(
                EvaIcons.logInOutline,
                color: Colors.red,
              )),
        ],
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.leftToRight));
          },
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
        backgroundColor: const Color(0xFF100E20),
        title: Container(
          //color: Colors.red,
          width: MediaQuery.of(context).size.width * 0.5,
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: const Color(0xFF100E20),
                backgroundImage:
                    NetworkImage(widget.documentSnapshot!['userimage']),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.documentSnapshot!['roomname'],
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('chatrooms')
                            .doc(widget.documentSnapshot!.id)
                            .collection('members')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else {
                            return Text(
                                '${snapshot.data!.docs.length.toString()} members',
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0));
                          }
                        })
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.black,
          child: Column(
            children: [
              AnimatedContainer(
                child:
                    Provider.of<GroupMessagingHlepers>(context, listen: false)
                        .showMessages(context, widget.documentSnapshot!,
                            widget.documentSnapshot!['useruid']),
                color: Colors.black,
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                duration: const Duration(seconds: 1),
                curve: Curves.bounceIn,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Container(
                  child: Row(
                    children: [
                      GestureDetector(
                        child: const CircleAvatar(
                          radius: 18.0,
                          backgroundColor: Colors.transparent,
                          backgroundImage:
                              AssetImage('assets/icons/sunflower.png'),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Container(
                          color: Colors.black,
                          width: MediaQuery.of(context).size.width * 0.75,
                          child: TextField(
                            controller: messageController,
                            style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 16.0),
                            decoration: const InputDecoration(
                              hintText: 'Type here ...',
                              hintStyle: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16.0),
                            ),
                          ),
                        ),
                      ),
                      FloatingActionButton(
                        onPressed: () {
                          if (messageController.text.isNotEmpty) {
                            Provider.of<GroupMessagingHlepers>(context,
                                    listen: false)
                                .sendMessage(context, widget.documentSnapshot!,
                                    messageController);
                          }
                        },
                        backgroundColor: Colors.blue,
                        child: const Icon(
                          Icons.send,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
