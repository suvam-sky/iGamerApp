// ignore_for_file: file_names, unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/Profile/profile_helpers.dart';
import 'package:the_social/screens/landingPage/landing_page.dart';
import 'package:the_social/services/authentication.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            EvaIcons.settings2Outline,
            color: Colors.lightBlue,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {
                Provider.of<ProfileHelpers>(context, listen: false)
                    .logoutDialog(context);
              },
              icon: const Icon(
                EvaIcons.logOutOutline,
                color: Colors.green,
              ))
        ],
        backgroundColor: Colors.blueGrey.withOpacity(0.4),
        title: RichText(
          text: const TextSpan(
              text: 'My ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              children: [
                TextSpan(
                    text: 'Profile',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ]),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.blueGrey.withOpacity(0.6)),
            child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(Provider.of<Authentication>(context, listen: false)
                      .getUserUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    children: [
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .headerProfile(context, snapshot.data!),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .middleProfile(context, snapshot.data!),
                      Provider.of<ProfileHelpers>(context, listen: false)
                          .footerProfile(context, snapshot.data!),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}
