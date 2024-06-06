import 'dart:io';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';

import '../models/user_model.dart';
import 'fire_database.dart';

class FireStorage
{
  final FirebaseStorage firestorage = FirebaseStorage.instance;

  Future sendimage({required File file,required String roomId,required String uid,
    required var chatUser,required BuildContext context}) async
  {
    String ext = file.path.split('.').last;
    final ref = firestorage.ref().
    child('image/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

   await ref.putFile(file);//to upload image on firestorage
    String imageUrl = await ref.getDownloadURL();
    FireData().sendMessage(uid, imageUrl, roomId,type: 'image',chatUser,context);
  }


  Future updateProfileImage({required File file}) async
  {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    String ext = file.path.split('.').last;
    final ref = firestorage.ref().
    child('profile/$uid/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);//to upload image on firestorage
    String imageUrl = await ref.getDownloadURL();
    await FirebaseFirestore.instance.collection('users').doc(uid).update({'image' : imageUrl});
  }



  Future sendfile({required File file,required String roomId,required String uid,
    required  var chatUser,required BuildContext context}) async
  {
    String ext = file.path.split('.').last;
    final ref = firestorage.ref().
    child('files/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);//to upload file on firestorage
    String fileUrl = await ref.getDownloadURL();
    FireData().sendMessage(uid, fileUrl, roomId,type: 'file',chatUser,context);
  }

  Future sendvideo({required File file,required String roomId,required String uid,
    required ChatUser chatUser,required BuildContext context}) async
  {
    String ext = file.path.split('.').last;
    final ref = firestorage.ref().
    child('pdfs/$roomId/${DateTime.now().millisecondsSinceEpoch}.$ext');

    await ref.putFile(file);//to upload file on firestorage
    String fileUrl = await ref.getDownloadURL();
    FireData().sendMessage(uid, fileUrl, roomId,type: 'video',chatUser,context);
  }

}