// ignore_for_file: sized_box_for_whitespace

import 'dart:async';

import 'package:circular_countdown_timer/circular_countdown_timer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/services/authentication.dart';

class Stories extends StatefulWidget {
  final DocumentSnapshot documentSnapshot;
  const Stories({Key? key, required this.documentSnapshot}) : super(key: key);

  @override
  _StoriesState createState() => _StoriesState();
}

class _StoriesState extends State<Stories> {
  // @override
  // void initState() {
  //   Timer(
  //       Duration(seconds: 15),
  //       () => Navigator.pushReplacement(
  //           context,
  //           PageTransition(
  //               child: const HomePage(),
  //               type: PageTransitionType.topToBottom)));
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100E20),
      body: GestureDetector(
        onPanUpdate: (update) {
          if (update.delta.dx > 0) {
            Navigator.pushReplacement(
                context,
                PageTransition(
                    child: const HomePage(),
                    type: PageTransitionType.topToBottom));
          }
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height,
                      width: MediaQuery.of(context).size.width,
                      child: Image.network(widget.documentSnapshot['image']),
                    )
                  ],
                ),
              ),
            ),
            Positioned(
                top: 30.0,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(context).size.width,
                  ),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Container(
                        child: CircleAvatar(
                          backgroundColor: const Color(0xFF100E20),
                          backgroundImage: NetworkImage(
                            widget.documentSnapshot['userimage'],
                          ),
                          radius: 25.0,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 4.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width * 0.55,
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.9,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.documentSnapshot['username'],
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16.0),
                              ),
                              const Text(
                                '2hours ago',
                                style: TextStyle(
                                    color: Colors.blue,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12.0),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Provider.of<Authentication>(context, listen: false)
                                  .getUserUid ==
                              widget.documentSnapshot['useruid']
                          ? GestureDetector(
                              onTap: () {},
                              child: Container(
                                height: 30.0,
                                width: 50.0,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    Icon(
                                      FontAwesomeIcons.solidEye,
                                      color: Colors.yellow,
                                      size: 16.0,
                                    ),
                                    Text('0',
                                        style: TextStyle(
                                            color: Colors.blue,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16.0))
                                  ],
                                ),
                              ),
                            )
                          : const SizedBox(
                              width: 0,
                              height: 0,
                            ),
                      SizedBox(
                        height: 30.0,
                        width: 30.0,
                        child: CircularCountDownTimer(
                          isTimerTextShown: false,
                          duration: 15,
                          ringColor: Colors.red,
                          fillColor: Colors.blue,
                          height: 20.0,
                          width: 20.0,
                        ),
                      ),
                      IconButton(
                          onPressed: () {
                            showMenu(
                                context: context,
                                position: const RelativeRect.fromLTRB(
                                    300.0, 70.0, 0, 0),
                                items: [
                                  PopupMenuItem(
                                      child: FlatButton.icon(
                                          onPressed: () {},
                                          color: Colors.blue,
                                          icon: const Icon(
                                            FontAwesomeIcons.archive,
                                            color: Colors.white,
                                          ),
                                          label:
                                              const Text('Add to highlights'))),
                                  PopupMenuItem(
                                      child: FlatButton.icon(
                                          onPressed: () {
                                            FirebaseFirestore.instance
                                                .collection('stories')
                                                .doc(
                                                    Provider.of<Authentication>(
                                                            context,
                                                            listen: false)
                                                        .getUserUid)
                                                .delete()
                                                .whenComplete(() {
                                              Navigator.pushReplacement(
                                                  context,
                                                  PageTransition(
                                                      child: const HomePage(),
                                                      type: PageTransitionType
                                                          .topToBottom));
                                            });
                                          },
                                          color: Colors.red,
                                          icon: const Icon(
                                            FontAwesomeIcons.archive,
                                            color: Colors.white,
                                          ),
                                          label: const Text('Delete'))),
                                ]);
                          },
                          icon: const Icon(
                            EvaIcons.moreVertical,
                            color: Colors.white,
                          ))
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
