import 'package:get_storage/get_storage.dart';
import 'package:graduateproject/features/App/screens/chat/utill/date_time.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';

import '../../models/message_model.dart';
import '../../models/room_model.dart';
import '../../models/user_model.dart';
import '../Chat_screen.dart';

class Chat_Card extends StatelessWidget {
  final ChatRoom item;
   Chat_Card({super.key, required this.item});

 final  role = GetStorage().read('role');
  //new

  @override
  Widget build(BuildContext context) {
    List member =item.members!.where(

            (element) => element != FirebaseAuth.instance.currentUser!.uid).toList();


    String userId = member.isEmpty ? FirebaseAuth.instance.currentUser!.uid : member.first;
    print(role+"==========================role");
    return
      StreamBuilder(
      stream: FirebaseFirestore.instance.collection(role == 'doctor' ? 'doctors' : 'users').doc(userId).snapshots(),
      builder: (context, AsyncSnapshot snapshot) {
        if (snapshot.hasData ) {
          // var userData = snapshot.data.docs;
          // ChatUser chatUser = ChatUser.fromjson(userData);
          return Card(
            child: ListTile(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Chat_screen(
                    chatUser: snapshot.data,
                    roomId: item.id ?? '',
                  ),
                ),
              ),
              leading: snapshot.data[role == 'doctor' ?'docimage' : 'image'].isEmpty
                  ? FullScreenWidget(
                disposeLevel: DisposeLevel.High,
                child: const CircleAvatar(
                  backgroundImage: AssetImage('assets/images/profile.png'),
                ),
              )
                  : FullScreenWidget(
                disposeLevel: DisposeLevel.High,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(snapshot.data[role == 'doctor' ?'docimage' : 'image']!),
                ),
              ),
              title: Text(snapshot.data[role == 'doctor' ?'docName' : 'name'] ?? 'Unknown'),
              subtitle: Text(
                item.lastMessage!.isEmpty ? snapshot.data[role == 'doctor' ?'docAbout' : 'about' ] ?? 'No details' : item.lastMessage!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('rooms')
                    .doc(item.id)
                    .collection('messages')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final unReadList = snapshot.data?.docs
                        .map((e) => Message.fromjson(e.data()))
                        .where((element) => element.read!.isEmpty)
                        .where((element) => element.fromId != FirebaseAuth.instance.currentUser?.uid) ??
                        [];
                    return unReadList.isNotEmpty
                        ? Badge(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      largeSize: 30,
                      label: Text(unReadList.length.toString()),
                    )
                        : Text(myDateTime.dateAndTime(item.lastMessageTime ?? DateTime.now.toString()));
                  } else {
                    return const Text('Loading...');
                  }
                },
              ),
            ),
          );
        } else {
          return const Center(child: CircularProgressIndicator());
        }
      },
    );

  }
}
