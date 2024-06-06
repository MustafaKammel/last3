import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationsServices {
  var user = FirebaseAuth.instance.currentUser;
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static onTap(NotificationResponse notificationResponse) {}

  Future init() async {
    InitializationSettings settings = const InitializationSettings(
      android: AndroidInitializationSettings("@mipmap/ic_launcher"),
      iOS: DarwinInitializationSettings(),
    );
    flutterLocalNotificationsPlugin.initialize(
      settings,
      onDidReceiveNotificationResponse: onTap,
      onDidReceiveBackgroundNotificationResponse: onTap,
    );
    // Timer.periodic(Duration(seconds: 30), (timer) {
      showBasicNotification();
    // });
  }

  // Basic notification
  void showBasicNotification() async {
    String? name = user!.displayName.toString();
    String id = user!.uid;
    NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails('id 1', 'basic notification ',
            importance: Importance.max, priority: Priority.high));

    FirebaseFirestore.instance
        .collection('notifications')
        .where('uid', isEqualTo: id)
        .where('isShow', isEqualTo: false)
        .get()
        .then((value) {
      value.docs.forEach((element) async {
        await flutterLocalNotificationsPlugin.show(
            0, element.get('title'), element.get('body'), details);
        FirebaseFirestore.instance
            .collection('notifications')
            .doc(element.id)
            .update({'isShow': true});
      });
    });
    print('===============================$name=================');
  }

}
