// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/Feed/feed_helpers.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';

class Feed extends StatelessWidget {
  const Feed({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const Drawer(),
      appBar: Provider.of<FeedHelpers>(context, listen: false).appBar(context),
      body: Provider.of<FeedHelpers>(context, listen: false).feedBody(context),
    );
  }
}

// Widget NavDrawer(BuildContext context) {
//   return Drawer(
//       child: ListView(
//     children: [
//       DrawerHeader(
//         child: Column(
//           children: [
//             Image(
//               image: NetworkImage(
//                   Provider.of<FirebaseOperations>(context, listen: false)
//                       .getInitUserImage!),
//               height: 70,
//             ),
//             Text(
//               Provider.of<FirebaseOperations>(context, listen: false)
//                   .getInitUserName!,
//               style: TextStyle(fontSize: 18, color: Colors.white),
//             ),
//             Text(
//               Provider.of<FirebaseOperations>(context, listen: false)
//                   .getInitUserEmail!,
//               style: TextStyle(fontSize: 14, color: Colors.white),
//             ),
//           ],
//         ),
//       )
//     ],
//   ));
// }
