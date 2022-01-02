// ignore_for_file: avoid_print, non_constant_identifier_names

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:the_social/screens/landingPage/landing_services.dart';

class LandingUtils with ChangeNotifier {
  final picker = ImagePicker();
  File? userAvater;
  File? get getUserAvater => userAvater;

  late String userAvaterUrl;
  String get UserAvaterUrl => userAvaterUrl;

  Future pickUserAvater(BuildContext context, ImageSource source) async {
    final pickedUserAvater = await picker.pickImage(source: source);
    pickedUserAvater == null
        ? print("select image ")
        : userAvater = File(pickedUserAvater.path);
    print("the pic path is =====>  " + userAvater!.path);
    print("the pic path .... =====>  " + userAvater.toString());

    userAvater != null
        ? Provider.of<LandingService>(context, listen: false)
            .showUserAvater(context)
        : print(".....................upload error.......................");
    notifyListeners();
  }

  Future selectAvatarOptionSheet(BuildContext context) async {
    return showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              child: Column(
                children: [
                  const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 150),
                      child: Divider(
                        thickness: 4.0,
                        color: Colors.white,
                      )),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MaterialButton(
                        onPressed: () {
                          pickUserAvater(context, ImageSource.gallery)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingService>(context, listen: false)
                                .showUserAvater(context);
                          });
                        },
                        child: const Text(
                          'Gallery',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                      MaterialButton(
                        onPressed: () {
                          pickUserAvater(context, ImageSource.camera)
                              .whenComplete(() {
                            Navigator.pop(context);
                            Provider.of<LandingService>(context, listen: false)
                                .showUserAvater(context);
                          });
                        },
                        child: const Text(
                          'Camera',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18),
                        ),
                      ),
                    ],
                  )
                ],
              ),
              height: MediaQuery.of(context).size.height * 0.1,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.circular(15)));
        });
  }
}
