import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:the_social/screens/AltProfile/alt_profile.dart';

class ChatHelpers with ChangeNotifier {
  Widget chatHeader(BuildContext context, dynamic snapshot) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
      width: double.infinity,
      child: Column(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.75,
            child: const Text(
              'Chat with friends',
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .doc(snapshot['useruid'])
                    .collection('following')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView(
                      scrollDirection: Axis.horizontal,
                      children: snapshot.data!.docs
                          .map((DocumentSnapshot documentSnapshot) {
                        return Container(
                          height: 80.0,
                          width: 60.0,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: CircleAvatar(
                                radius: 24,
                                backgroundImage: NetworkImage(
                                    documentSnapshot['userimage'])),
                          ),
                        );
                      }).toList(),
                    );
                  }
                }),
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: const Color(0xFF100E20).withOpacity(0.4),
                borderRadius: BorderRadius.circular(2.0)),
          ),
        ],
      ),
    );
  }

  Widget chatBody(BuildContext context, dynamic snapshot) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25),
            topRight: Radius.circular(25),
          ),
        ),
        child: Container(
            height: MediaQuery.of(context).size.height * 0.4,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                //color: const Color(0xFF100E20),
                borderRadius: BorderRadius.circular(2.0)),
            child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(snapshot['useruid'])
                  .collection('following')
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
                        Navigator.push(
                            context,
                            PageTransition(
                                child: AltProfile(
                                    userUid: documentSnapshot['useruid']),
                                type: PageTransitionType.leftToRight));
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
                    );
                  }).toList());
                }
              },
            )),
      ),
    );
  }
}
