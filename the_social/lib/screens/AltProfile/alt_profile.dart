// ignore_for_file: use_key_in_widget_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/AltProfile/altprofile_helpers.dart';

class AltProfile extends StatelessWidget {
  final String userUid;
  const AltProfile({required this.userUid});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Provider.of<AltProfileHelpers>(context, listen: false)
          .appBar(context),
      body: SingleChildScrollView(
        child: Container(
          child: StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(userUid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Provider.of<AltProfileHelpers>(context, listen: false)
                          .headerprofile(context, snapshot, userUid),
                      Provider.of<AltProfileHelpers>(context, listen: false)
                          .divider(),
                      Provider.of<AltProfileHelpers>(context, listen: false)
                          .middleProfile(context, snapshot),
                      Provider.of<AltProfileHelpers>(context, listen: false)
                          .footerProfile(context, snapshot)
                    ],
                  );
                }
              }),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
              color: Colors.blueGrey,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(12), topRight: Radius.circular(12))),
        ),
      ),
    );
  }
}
