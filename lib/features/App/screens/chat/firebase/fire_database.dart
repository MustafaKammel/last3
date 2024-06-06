import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;

import '../models/group_model.dart';
import '../models/message_model.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import '../provider/provider.dart';

class FireData {
  final FirebaseFirestore Firestore = FirebaseFirestore.instance;
  final String myUid = FirebaseAuth.instance.currentUser!.uid;
  String now = DateTime.now().millisecondsSinceEpoch.toString();

  Future createRoom(String email) async {
    print(email+"=============================");

    QuerySnapshot userEmail = await Firestore.collection('doctors')
        .where('docEmail', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first.id;

      print(userId+"=============================");
      List<String> members = [myUid, userId]..sort(
          (a, b) => a.compareTo(b),
        );
      QuerySnapshot roomExist = await Firestore.collection('rooms')
          .where('members', isEqualTo: members)
          .get();

      if (roomExist.docs.isEmpty) {
        ChatRoom chatRoom = ChatRoom(
          id: members.toString(),
          createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
          lastMessage: "",
          lastMessageTime: DateTime.now().millisecondsSinceEpoch.toString(),
          members: members,
        );

        await Firestore.collection('rooms')
            .doc(members.toString())
            .set(chatRoom.tojson());
      } else {
        Fluttertoast.showToast(msg: "Room already exist");
      }
    } else {
      Fluttertoast.showToast(msg: "Email not found or Email has error");
    }
  }

  Future createGroup(String name, List members) async {
    String gId = const Uuid().v1();
    members.add(myUid);
    ChatGroup chatGroup = ChatGroup(
      id: gId,
      createdAt: now,
      lastMessage: '',
      lastMessageTime: now,
      members: members,
      name: name,
      image: '',
      admin: [myUid],
    );
    await Firestore.collection('groups').doc(gId).set(chatGroup.tojson());
  }

  Future addContact(String email) async {
    QuerySnapshot userEmail = await Firestore.collection('users')
        .where('email', isEqualTo: email)
        .get();

    if (userEmail.docs.isNotEmpty) {
      String userId = userEmail.docs.first.id;

      Firestore.collection('users').doc(myUid).update({
        'my_users': FieldValue.arrayUnion([userId])
      });
    }
  }

  Future sendMessage(String uid, String msg, String roomId, var chatUser,
      BuildContext context,
      {String? type}) async {
    String msgId = const Uuid().v1();
    Message message = Message(
      id: msgId,
      toId: uid,
      fromId: myUid,
      msg: msg,
      type: type ?? 'text',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      read: '',
    );
    await Firestore.collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .set(message.tojson())
        .then((value) => sendNotification(
            chatUser: chatUser, context: context, msg: type ?? msg));

    await Firestore.collection('rooms').doc(roomId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future readMessage(String roomId, String msgId) async {
    await Firestore.collection('rooms')
        .doc(roomId)
        .collection('messages')
        .doc(msgId)
        .update({'read': DateTime.now().millisecondsSinceEpoch.toString()});
  }

  Future deleteMsg(String roomId, List<String> msgs) async {
    if (msgs.length == 1) {
      await Firestore.collection('rooms')
          .doc(roomId)
          .collection('messages')
          .doc(msgs.first)
          .delete();
    } else {
      for (var element in msgs) {
        await Firestore.collection('rooms')
            .doc(roomId)
            .collection('messages')
            .doc(element)
            .delete();
      }
    }
  }

  Future sendGMessage(
      String msg, String groupId, BuildContext context, ChatGroup chatGroup,
      {String? type}) async {
    List<ChatUser> chatUsers = [];
    chatGroup.members =
        chatGroup.members.where((element) => element != myUid).toList();
    Firestore.collection('users')
        .where('id', whereIn: chatGroup.members)
        .get()
        .then((value) => chatUsers
            .addAll(value.docs.map((e) => ChatUser.fromjson(e.data()))));
    String msgId = const Uuid().v1();
    Message message = Message(
      id: msgId,
      toId: '',
      fromId: myUid,
      msg: msg,
      type: type ?? 'text',
      createdAt: DateTime.now().millisecondsSinceEpoch.toString(),
      read: '',
    );
    await Firestore.collection('groups')
        .doc(groupId)
        .collection('messages')
        .doc(msgId)
        .set(message.tojson())
        .then((value) {
      for (var element in chatUsers) {
        sendNotification(
            chatUser: element,
            context: context,
            msg: type ?? msg,
            groupName: chatGroup.name);
      }
    });

    await Firestore.collection('groups').doc(groupId).update({
      'last_message': type ?? msg,
      'last_message_time': DateTime.now().millisecondsSinceEpoch.toString(),
    });
  }

  Future editGroup(String gId, String name, List members) async {
    await Firestore.collection('groups').doc(gId).update({
      'name': name,
      'members': FieldValue.arrayUnion(members),
    });
  }

  Future removeMember(String gId, String memberId) async {
    await Firestore.collection('groups').doc(gId).update({
      'members': FieldValue.arrayRemove([memberId]),
    });
  }

  Future promptAdmin(String gId, String memberId) async {
    await Firestore.collection('groups').doc(gId).update({
      'admins_id': FieldValue.arrayRemove([memberId]),
    });
  }

  Future removeAdmin(String gId, String memberId) async {
    await Firestore.collection('groups').doc(gId).update({
      'admins_id': FieldValue.arrayRemove([memberId]),
    });
  }

  Future editProfile(String name, String about) async {
    await Firestore.collection('users')
        .doc(myUid)
        .update({'name': name, 'about': about});
  }

  sendNotification(
      {required var chatUser,
      required BuildContext context,
      required String msg,
      String? groupName}) async {
    final header = {
      'Content-Type': 'application/json',
      'Authorization':
          'key=AAAAbSgmrC0:APA91bGGCl90HMprfjdasJr6RAHUUBkpyL4wJKARIRZloaxN3HRLUW1TGSTvVZEHhc-sOjdBKOKJSOCVbyABfrhm2TfyVckL-NBWdiQbAGb81oZszkOFbdMLZVn2o48MFdlpBQ1E44Jc',
    };
    final body = {
      'to': chatUser['docPuch_token'], //token
      "notification": {
        "title": groupName == null
            ? Provider.of<providerApp>(context, listen: false).me!.name
            : groupName +
                ' : ' +
                "${Provider.of<providerApp>(context, listen: false).me!.name}", //name of user will send the message to
        "body": msg,
      }
    };
    final req = await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        body: jsonEncode(body),
        headers: header);
    print(req.statusCode);
  }
}
