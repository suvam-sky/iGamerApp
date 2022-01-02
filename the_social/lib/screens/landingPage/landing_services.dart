// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors, avoid_print

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/HomePage/home_page.dart';
import 'package:the_social/screens/landingPage/landing_utils.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class LandingService with ChangeNotifier {
  TextEditingController userEmailController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController userPasswordController = TextEditingController();

  Widget passwordLessSignIn(BuildContext context) {
    return SizedBox(
        height: MediaQuery.of(context).size.height * 0.4,
        width: MediaQuery.of(context).size.width,
        child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance.collection('users').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                  children: snapshot.data!.docs
                      .map((DocumentSnapshot documentSnapshot) {
                return ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      backgroundImage:
                          NetworkImage(documentSnapshot['userimage']),
                    ),
                    subtitle: Text(
                      documentSnapshot[
                          'useremail'], //documentSnapshot.data()!['useremail']
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                          fontSize: 12.0),
                    ),
                    title: Text(
                      documentSnapshot['username'],
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.green,
                      ),
                    ),
                    trailing: SizedBox(
                      width: 120.0,
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                              onPressed: () {
                                Provider.of<Authentication>(context,
                                        listen: false)
                                    .logIntoAccount(
                                        documentSnapshot['useremail'],
                                        documentSnapshot['userpassword'])
                                    .whenComplete(() {
                                  Navigator.pop(context);
                                }).whenComplete(() async {
                                  Navigator.pushReplacement(
                                      context,
                                      PageTransition(
                                          child: HomePage(),
                                          type:
                                              PageTransitionType.leftToRight));
                                  //notifyListeners();
                                });
                              },
                              icon: Icon(
                                FontAwesomeIcons.check,
                                color: Colors.blue,
                              )),
                          IconButton(
                              onPressed: () {
                                Provider.of<FirebaseOperations>(context,
                                        listen: false)
                                    .deleteUserData(
                                        documentSnapshot['useruid']);
                              },
                              icon: Icon(
                                FontAwesomeIcons.trashAlt,
                                color: Colors.red,
                              )),
                        ],
                      ),
                    ));
              }).toList());
            }
          },
        ));
  }

  logInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              height: MediaQuery.of(context).size.height * 0.30,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                          hintText: "Enter Email...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                          hintText: "Enter password...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  FloatingActionButton(
                      child: Icon(
                        FontAwesomeIcons.check,
                        color: Colors.white,
                      ),
                      backgroundColor: Colors.blue,
                      onPressed: () {
                        if (userEmailController.text.isNotEmpty) {
                          Provider.of<Authentication>(context, listen: false)
                              .logIntoAccount(userEmailController.text,
                                  userPasswordController.text)
                              .whenComplete(() {
                            Navigator.pop(context);
                          }).whenComplete(() {
                            Navigator.pushReplacement(
                                context,
                                PageTransition(
                                    child: HomePage(),
                                    type: PageTransitionType.bottomToTop));
                          });
                        } else {
                          warningText(context, 'Fill all the data..');
                        }
                      })
                ],
              ),
            ),
          );
        });
  }

  signInSheet(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.5,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12))),
              child: Column(
                children: [
                  Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  CircleAvatar(
                    backgroundImage: FileImage(
                        Provider.of<LandingUtils>(context, listen: false)
                            .getUserAvater!),
                    backgroundColor: Colors.red,
                    radius: 60.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userNameController,
                      decoration: InputDecoration(
                          hintText: "Enter name...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userEmailController,
                      decoration: InputDecoration(
                          hintText: "Enter Email...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TextField(
                      controller: userPasswordController,
                      decoration: InputDecoration(
                          hintText: "Enter password...",
                          hintStyle: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16.0)),
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: FloatingActionButton(
                        child: Icon(
                          FontAwesomeIcons.check,
                          color: Colors.white,
                        ),
                        backgroundColor: Colors.red,
                        onPressed: () {
                          if (userEmailController.text.isNotEmpty) {
                            Provider.of<Authentication>(context, listen: false)
                                .createAccount(userEmailController.text,
                                    userPasswordController.text)
                                .whenComplete(() {
                              print(
                                  "creating data................................");
                              Provider.of<FirebaseOperations>(context,
                                      listen: false)
                                  .createUserCollevctions(context, {
                                'userpassword': userPasswordController.text,
                                'useruid': Provider.of<Authentication>(context,
                                        listen: false)
                                    .getUserUid,
                                'useremail': userEmailController.text,
                                'username': userNameController.text,
                                'userimage': Provider.of<LandingUtils>(context,
                                        listen: false)
                                    .userAvaterUrl
                              });
                            }).whenComplete(() {
                              Navigator.pushReplacement(
                                  context,
                                  PageTransition(
                                      child: HomePage(),
                                      type: PageTransitionType.bottomToTop));
                            });
                          } else {
                            warningText(context, 'Fill all the data..');
                          }
                        }),
                  )
                ],
              ),
            ),
          );
        });
  }

  warningText(BuildContext context, String warning) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            decoration: BoxDecoration(
                color: Colors.red, borderRadius: BorderRadius.circular(10)),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: Text(
                warning,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold),
              ),
            ),
          );
        });
  }

  showUserAvater(BuildContext context) {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: MediaQuery.of(context).size.height * 0.35,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: Colors.blueGrey,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(horizontal: 150),
                    child: Divider(
                      thickness: 4.0,
                      color: Colors.white,
                    )),
                CircleAvatar(
                  radius: 80.0,
                  backgroundColor: Colors.transparent,
                  backgroundImage: FileImage(
                      Provider.of<LandingUtils>(context, listen: false)
                          .userAvater!),
                ),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      MaterialButton(
                          child: Text(
                            'Reselect',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                                decorationColor: Colors.white),
                          ),
                          onPressed: () {
                            Provider.of<LandingUtils>(context, listen: false)
                                .pickUserAvater(context, ImageSource.gallery);
                          }),
                      MaterialButton(
                          color: Colors.blue,
                          child: Text(
                            'Confirm image',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          onPressed: () {
                            Provider.of<FirebaseOperations>(context,
                                    listen: false)
                                .uploadUserAvater(context)
                                .whenComplete(() {
                              signInSheet(context);
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
}
