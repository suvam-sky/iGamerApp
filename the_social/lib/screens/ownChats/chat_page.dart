import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:the_social/screens/ownChats/chat_helpers.dart';
import 'package:the_social/services/authentication.dart';

class ChatsPage extends StatelessWidget {
  const ChatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red,
      body: SafeArea(
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
                  Provider.of<ChatHelpers>(context, listen: false)
                      .chatHeader(context, snapshot.data),
                  Provider.of<ChatHelpers>(context, listen: false)
                      .chatBody(context, snapshot.data)
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
