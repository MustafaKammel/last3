
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../firebase/fire_auth.dart';
import '../models/user_model.dart';

class providerApp with ChangeNotifier
{
ThemeMode themeMode = ThemeMode.system;
int mainColor = 0xff9625A9;
ChatUser? me;
String? myId = '';

Future<void> getUserDetails() async
{
  myId = FirebaseAuth.instance.currentUser!.uid;
  await FirebaseFirestore.instance.collection('users').doc(myId).get().
  then((value) => me = ChatUser.fromjson(value.data()!));

 await FirebaseMessaging.instance.requestPermission();
  await FirebaseMessaging.instance.getToken().then((value) {
    if(value != null){
      me!.puchToken = value;
      FireAuth().getToken(value);
    }
  });
  notifyListeners();
}

Future<void> signout_removed()async
{
  myId = '';
  notifyListeners();
}



ChangeMode(bool dark)async
{
  final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  themeMode = dark ? ThemeMode.dark : ThemeMode.light;
  sharedPreferences.setBool('dark', themeMode == ThemeMode.dark);
  notifyListeners();
}

changeColor(int c) async
{
  final SharedPreferences sharedPreferences =await SharedPreferences.getInstance();
  mainColor = c;
  sharedPreferences.setInt('color', mainColor);
  notifyListeners();
}

getValuesPref() async
{
  final SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  bool isDark = sharedPreferences.getBool('dark') ?? false;
  themeMode = isDark ? ThemeMode.dark : ThemeMode.light;
  mainColor = sharedPreferences.getInt('color') ?? 0xff9625A9;
  notifyListeners();
}

}