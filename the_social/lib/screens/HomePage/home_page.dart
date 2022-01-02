// ignore_for_file: unused_import

import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/ChatRoom/chatroom.dart';
import 'package:the_social/screens/Feed/Feed.dart';
import 'package:the_social/screens/HomePage/homepage_helpers.dart';
import 'package:the_social/screens/Profile/Profile.dart';
import 'package:the_social/screens/ownChats/chat_page.dart';
import 'package:the_social/services/firebase_operations.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final PageController homepageController = PageController();
  int pageIndex = 0;

  @override
  void initState() {
    Provider.of<FirebaseOperations>(context, listen: false)
        .initUserData(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF100E20),
      body: PageView(
        controller: homepageController,
        children: const [Feed(), CharRoom(), ChatsPage(), Profile()],
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (page) {
          setState(() {
            pageIndex = page;
          });
        },
      ),
      bottomNavigationBar: Provider.of<HomepageHelpers>(context, listen: false)
          .bottomNavBar(context, pageIndex, homepageController),
    );
  }
}
