// ignore_for_file: file_names

import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/ChatRoom/chatroom_helpers.dart';

class CharRoom extends StatelessWidget {
  const CharRoom({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrangeAccent,
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(EvaIcons.moreVertical, color: Colors.white))
        ],
        leading: IconButton(
            onPressed: () {
              Provider.of<ChatroomHelpers>(context, listen: false)
                  .showCreateChatroomSheet(context);
            },
            icon: const Icon(
              FontAwesomeIcons.plus,
              color: Colors.green,
            )),
        title: RichText(
          text: const TextSpan(
              text: 'Chat ',
              style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0),
              children: [
                TextSpan(
                    text: 'Room',
                    style: TextStyle(
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0))
              ]),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueGrey,
        child: const Icon(
          FontAwesomeIcons.plus,
          color: Colors.green,
        ),
        onPressed: () {
          Provider.of<ChatroomHelpers>(context, listen: false)
              .showCreateChatroomSheet(context);
        },
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: Provider.of<ChatroomHelpers>(context, listen: false)
            .showChatRooms(context),
      ),
    );
  }
}
