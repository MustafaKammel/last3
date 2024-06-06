// import 'package:chat_udemy/models/message_model.dart';
// import 'package:chat_udemy/utill/colors.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
// import 'package:intl/intl.dart';
//
// class GroupMessageCard extends StatelessWidget {
//   const GroupMessageCard({super.key, required this.index, required this.message});
//   final int index;
//   final Message message;
//
//   @override
//   Widget build(BuildContext context) {
//     bool isMe = message.fromId == FirebaseAuth.instance.currentUser!.uid;
//     return StreamBuilder(
//         stream: FirebaseFirestore.instance.
//         collection('users').doc(message.fromId).snapshots(),
//       builder: (context, snapshot) {
//         return snapshot.hasData ? Row(
//           mainAxisAlignment:isMe ? MainAxisAlignment.end:MainAxisAlignment.start,
//           children: [
//             isMe ? IconButton(onPressed: (){}, icon: const Icon(Iconsax.message_edit)) :const SizedBox(),
//             Card(
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.only(
//                   bottomLeft: Radius.circular(isMe ?10:0),
//                   bottomRight: Radius.circular(isMe ?0:10),
//                   topLeft: const Radius.circular(10),
//                   topRight: const Radius.circular(10),
//                 ),
//               ),
//               color: isMe ? Colors.grey : kprimary.withOpacity(0.5) ,
//               child: Padding(
//                 padding: const EdgeInsets.all(12.0),
//                 child: Container(
//                   constraints: BoxConstraints(
//                     maxWidth: MediaQuery.sizeOf(context).width /2 ,
//                   ),
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       !isMe ?  Text(snapshot.data!.data()!['name'],
//                             style: Theme.of(context).textTheme.labelLarge,)
//                               : Container(),
//
//
//                       const SizedBox(height: 4),
//                       Text(message.msg!,style: const TextStyle(fontSize: 20,fontWeight: FontWeight.bold)),
//                       const SizedBox(height: 4),
//                       Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           isMe ? const Icon(Iconsax.tick_circle,color: Colors.blueAccent,):const SizedBox(),
//                           const SizedBox(width: 10),
//         Text(
//         DateFormat.Hms().format(
//         DateTime.fromMillisecondsSinceEpoch(
//         int.parse(message.createdAt!)
//         )
//         ).toString()
//         ),//دي علشان الوقت
//         const SizedBox(width: 4),
//         Text(
//         DateFormat.yMMMEd().format(
//         DateTime.fromMillisecondsSinceEpoch(
//         int.parse(message.createdAt!)
//         )
//         ).toString(),
//         style: const TextStyle(fontSize: 10),
//         ),
//                         ],
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ) : Container();
//       }
//     );
//   }
// }
