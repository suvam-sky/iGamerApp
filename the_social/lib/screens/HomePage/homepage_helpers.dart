import 'package:custom_navigation_bar/custom_navigation_bar.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/services/firebase_operations.dart';

class HomepageHelpers with ChangeNotifier {
  Widget bottomNavBar(
      BuildContext context, int index, PageController pageController) {
    return CustomNavigationBar(
      currentIndex: index,
      //bubbleCurve: Curves.ease,
      scaleCurve: Curves.linear,
      selectedColor: Colors.blue,
      unSelectedColor: Colors.white,
      //strokeColor: Colors.green,
      //scaleFactor: 0.5,
      iconSize: 30.0,
      onTap: (val) {
        index = val;
        pageController.jumpToPage(val);
        notifyListeners();
      },
      backgroundColor: Colors.black,
      items: [
        CustomNavigationBarItem(
            icon: const Icon(EvaIcons.home),
            title: const Text(
              'Home',
              style: TextStyle(color: Colors.white),
            )),
        CustomNavigationBarItem(
            icon: const Icon(EvaIcons.messageCircle),
            title: const Text('Group chats',
                style: TextStyle(color: Colors.white))),
        CustomNavigationBarItem(
            icon: const Icon(EvaIcons.messageSquare),
            title: const Text('Chats', style: TextStyle(color: Colors.white))),
        CustomNavigationBarItem(
            title: const Text('Profile', style: TextStyle(color: Colors.white)),
            icon: CircleAvatar(
              radius: 35.0,
              backgroundColor: Colors.blueGrey,
              backgroundImage: NetworkImage(
                  Provider.of<FirebaseOperations>(context, listen: false)
                      .getInitUserImage),
            )),
      ],
    );
  }
}
