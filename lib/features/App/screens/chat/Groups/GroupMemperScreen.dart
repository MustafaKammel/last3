// import 'package:chat_udemy/Groups/edit_group.dart';
// import 'package:chat_udemy/firebase/fire_database.dart';
// import 'package:chat_udemy/models/group_model.dart';
// import 'package:chat_udemy/models/user_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class GroupMemperScreen extends StatefulWidget {
//   const GroupMemperScreen({super.key, required this.chatGroup});
//   final ChatGroup chatGroup;
//
//   @override
//   State<GroupMemperScreen> createState() => _GroupMemperScreenState();
// }
//
// class _GroupMemperScreenState extends State<GroupMemperScreen> {
//   @override
//   Widget build(BuildContext context) {
//     bool isAdmin = widget.chatGroup.admin.contains(FirebaseAuth.instance.currentUser!.uid);
//     String myId = FirebaseAuth.instance.currentUser!.uid;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Group Mempers'),
//         actions: [
//           isAdmin ? IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(builder: (context) => Edit_group(
//               chatGroup: widget.chatGroup,
//             ),));
//           }, icon: const Icon(Iconsax.user_edit))
//               : Container(),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Column(
//           children: [
//             Expanded(
//               child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection('users').
//                 where('id', whereIn: widget.chatGroup.members).snapshots(),
//                 builder: (context, snapshot) {
//                   if(snapshot.hasData)
//                   {
//                     List<ChatUser> userList = snapshot.data!.docs.
//                     map((e) => ChatUser.fromjson(e.data())).toList();
//
//                     return ListView.builder(
//                       itemCount: userList.length,
//                       itemBuilder: (context, index) {
//                         bool admin = widget.chatGroup.admin.contains(userList[index].id);
//                         return ListTile(
//                           title: Text(userList[index].name!),
//                           subtitle:admin ? const Text('Admin',style: TextStyle(color: Colors.greenAccent),)
//                               : const Text('member',style: TextStyle(fontSize: 10)),
//                           trailing: Row(
//                             mainAxisSize: MainAxisSize.min,
//                             children: [
//                               isAdmin && myId != userList[index].id ?
//                               IconButton(onPressed: (){
//                                 admin ? FireData().removeMember(widget.chatGroup.id, userList[index].id!).then(
//                                         (value) {
//                                   setState(() {
//                                     widget.chatGroup.admin.remove(userList[index].id!);
//                                   });
//                                 })
//                                     :
//                                 FireData().promptAdmin(widget.chatGroup.id, userList[index].id!).then(
//                                         (value) {
//                                       setState(() {
//                                         widget.chatGroup.admin.add(userList[index].id!);
//                                       });
//                                     });
//                               }, icon: const Icon(Iconsax.user_tick)) : Container(),
//
//                               isAdmin && myId != userList[index].id ? IconButton(onPressed: (){
//                                 FireData().removeMember(widget.chatGroup.id, userList[index].id!).then(
//                                         (value) {
//                                           setState(() {
//                                             widget.chatGroup.members.remove(userList[index].id!);
//                                           });
//                                         }
//                                 );
//                               }, icon: const Icon(Iconsax.trash)) : Container(),
//                             ],
//                           ),
//                         );
//                       },
//                     );
//                   }
//                   else{
//                     return Container();
//                   }
//
//                 }
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
