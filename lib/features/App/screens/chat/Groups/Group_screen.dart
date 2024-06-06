// import 'package:chat_udemy/Groups/GroupMemperScreen.dart';
// import 'package:chat_udemy/Groups/widgets/GroupMessageCard.dart';
// import 'package:chat_udemy/firebase/fire_database.dart';
// import 'package:chat_udemy/models/group_model.dart';
// import 'package:chat_udemy/models/message_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class Group_screen extends StatefulWidget {
//   const Group_screen({super.key, required this.chatGroup});
//   final ChatGroup chatGroup;
//
//   @override
//   State<Group_screen> createState() => _Group_screenState();
// }
//
// class _Group_screenState extends State<Group_screen> {
//   TextEditingController msgcon = TextEditingController();
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.purple,
//         title: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(widget.chatGroup.name,style: const TextStyle(fontSize: 20)),
//             StreamBuilder(
//               stream: FirebaseFirestore.instance.collection('users').
//               where('id', whereIn: widget.chatGroup.members).snapshots(),
//               builder: (context, snapshot) {
//                 if(snapshot.hasData)
//                 {
//                   List membersName = [];
//                   for(var element in snapshot.data!.docs)
//                   {
//                     membersName.add(element.data()['name']);
//                   }
//                   return Text(membersName.join(' , '),style: Theme.of(context).textTheme.labelLarge,);
//                 }
//                 return Container();
//               }
//             ),
//           ],
//         ),
//         actions: [
//           IconButton(onPressed: (){
//             Navigator.push(context, MaterialPageRoute(
//               builder: (context) => GroupMemperScreen(
//                 chatGroup: widget.chatGroup,
//               ),
//             ),
//             );
//           }, icon: const Icon(Iconsax.user)),
//           // IconButton(onPressed: (){
//           //
//           //
//           // },
//           //     icon: Icon(Iconsax.copy)),
//         ],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(vertical: 5,horizontal: 20),
//         child: Column(
//           children: [
//             Expanded(
//               child:
//                 StreamBuilder (
//                   stream: FirebaseFirestore.instance.collection('groups').
//                   doc(widget.chatGroup.id).collection('messages').
//                   snapshots(),
//                   builder: (context, snapshot) {
//                     if(snapshot.hasData)
//                     {
//                       final List<Message> msgs = snapshot.data!.docs.
//                       map((e) => Message.fromjson(e.data())).toList()
//                         ..sort((a, b) => b.createdAt!.compareTo(a.createdAt!),);
//                       if(msgs.isEmpty){
//                         return
//                           Center(
//                             child: GestureDetector(
//                               onTap: () {
//                                 // Fluttertoast.showToast(
//                                 //   msg: "This is a toast To Say Hi",
//                                 //   toastLength: Toast.LENGTH_SHORT,
//                                 //   gravity: ToastGravity.BOTTOM,
//                                 //   backgroundColor: Colors.white,
//                                 //   textColor: Colors.black87,
//                                 // );
//                                 FireData().sendGMessage("Say Hi For First Time 👋",
//                                     widget.chatGroup.id,context,widget.chatGroup);
//                               },
//                               child: const Card(
//                                 child: Padding(
//                                   padding: EdgeInsets.all(12.0),
//                                   child: Column(
//                                     mainAxisSize: MainAxisSize.min,
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       Text('👋',style: TextStyle(fontSize: 50),),
//                                       Text('Say Hi'),
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           );
//                       }
//                       else{
//                         return ListView.builder(
//                           itemCount: msgs.length,
//                           reverse: true,
//                           itemBuilder: (context, index) {
//                             return  GroupMessageCard(
//                               message: msgs[index],
//                               index: index,
//                             );
//                           },
//                         );
//                       }
//                     }else{
//                       return Container();
//                     }
//
//                   }
//                 ),
//               // Center(
//               //   child: GestureDetector(
//               //     onTap: () {
//               //       Fluttertoast.showToast(
//               //         msg: "This is a toast To Say Hi",
//               //         toastLength: Toast.LENGTH_SHORT,
//               //         gravity: ToastGravity.BOTTOM,
//               //         backgroundColor: Colors.white,
//               //         textColor: Colors.black87,
//               //       );
//               //     },
//               //     child: Card(
//               //       child: Padding(
//               //         padding: const EdgeInsets.all(12.0),
//               //         child: Column(
//               //           mainAxisSize: MainAxisSize.min,
//               //           mainAxisAlignment: MainAxisAlignment.center,
//               //           children: [
//               //             Text('👋',style: TextStyle(fontSize: 50),),
//               //             Text('Say Hi'),
//               //           ],
//               //         ),
//               //       ),
//               //     ),
//               //   ),
//               // ),
//             ),
//             Row(
//               children: [
//                 Expanded(
//                   child: Card(
//                     child: TextField(
//                       controller: msgcon,
//                       maxLines: 5,
//                       minLines: 1,
//                       decoration: InputDecoration(
//                         suffix: Row(
//                           mainAxisAlignment: MainAxisAlignment.end,
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             IconButton.filledTonal(onPressed: (){}, icon: const Icon(Iconsax.emoji_happy5)),
//                             const SizedBox(width: 5),
//                             IconButton.filledTonal(onPressed: (){}, icon: const Icon(Iconsax.camera),),
//                           ],
//                         ),
//                         border: InputBorder.none,
//                         hintText: "Message",
//                         contentPadding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
//                       ),
//                     ),
//                   ),
//                 ),
//                 const SizedBox(width: 15,),
//                 IconButton.filled(
//                     onPressed: (){
//                   if(msgcon.text.isNotEmpty)
//                   {
//                     FireData().sendGMessage(msgcon.text, widget.chatGroup.id,context,widget.chatGroup).then(
//                             (value) {
//                               setState(() {
//                                 msgcon.text = "";
//                               });
//                             }
//                     );
//                   }
//                 }, icon: const Icon(Iconsax.send_1)),
//               ],
//             ),
//
//           ],
//         ),
//       ),
//     );
//   }
// }
