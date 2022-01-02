// ignore_for_file: unused_import

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:the_social/constants/Constantcolors.dart';
import 'package:the_social/screens/AltProfile/altprofile_helpers.dart';
import 'package:the_social/screens/ChatRoom/chatroom_helpers.dart';
import 'package:the_social/screens/Feed/feed_helpers.dart';
import 'package:the_social/screens/HomePage/homepage_helpers.dart';
import 'package:the_social/screens/Messaging/group_messaging_helpers.dart';
import 'package:the_social/screens/Profile/profile_helpers.dart';
import 'package:the_social/screens/Splachscreen/splash_screen.dart';
import 'package:the_social/screens/Stories/stories_helpers.dart';
import 'package:the_social/screens/landingPage/landing_helpers.dart';
import 'package:the_social/screens/landingPage/landing_page.dart';
import 'package:the_social/screens/landingPage/landing_services.dart';
import 'package:the_social/screens/landingPage/landing_utils.dart';
import 'package:the_social/screens/ownChats/chat_helpers.dart';
import 'package:the_social/services/authentication.dart';
import 'package:the_social/services/firebase_operations.dart';
import 'package:the_social/utils/post_options.dart';
import 'package:the_social/utils/upload_post.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //ConstantColors constantColors = ConstantColors();

    return MultiProvider(
        child: MaterialApp(
          title: 'The Social',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primarySwatch: Colors.blue,
              fontFamily: 'Poppins',
              canvasColor: Colors.transparent),
          home: const SplashScreen(),
        ),
        providers: [
          ChangeNotifierProvider(create: (_) => StoriesHelpers()),
          ChangeNotifierProvider(create: (_) => ChatHelpers()),
          ChangeNotifierProvider(create: (_) => GroupMessagingHlepers()),
          ChangeNotifierProvider(create: (_) => ChatroomHelpers()),
          ChangeNotifierProvider(create: (_) => AltProfileHelpers()),
          ChangeNotifierProvider(create: (_) => PostFunctions()),
          ChangeNotifierProvider(create: (_) => FeedHelpers()),
          ChangeNotifierProvider(create: (_) => UploadPost()),
          ChangeNotifierProvider(create: (_) => ProfileHelpers()),
          ChangeNotifierProvider(create: (_) => HomepageHelpers()),
          ChangeNotifierProvider(create: (_) => LandingUtils()),
          ChangeNotifierProvider(create: (_) => FirebaseOperations()),
          ChangeNotifierProvider(create: (_) => LandingService()),
          ChangeNotifierProvider(create: (_) => Authentication()),
          ChangeNotifierProvider(create: (_) => LandingHelpers())
        ]);
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
