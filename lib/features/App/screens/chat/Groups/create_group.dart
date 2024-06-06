// import 'package:chat_udemy/firebase/fire_database.dart';
// import 'package:chat_udemy/models/user_model.dart';
// import 'package:chat_udemy/utill/custom_text_filed.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class Create_group extends StatefulWidget {
//   const Create_group({super.key});
//
//   @override
//   State<Create_group> createState() => _Create_groupState();
// }
//
// class _Create_groupState extends State<Create_group> {
//   TextEditingController Gnamcon = TextEditingController();
//   List<String> members =[];
//   List myContacts = [];
//
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       floatingActionButton:members.isNotEmpty ? FloatingActionButton.extended(
//           onPressed: (){
//         FireData().createGroup(Gnamcon.text, members).then((value) {
//           Navigator.pop(context);
//           setState(() {
//             members = [];
//           });
//         });
//       }, label: const Text('Done'),icon: const Icon(Iconsax.tick_circle),
//       ) : Container(),
//       appBar: AppBar(
//         title: const Text('Create group'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Row(
//               children: [
//                 Padding(
//                   padding: const EdgeInsets.only(top: 10),
//                   child: Stack(
//                     clipBehavior: Clip.none,
//                     children: [
//                       const CircleAvatar(
//                         radius: 40,
//                       ),
//                       Positioned(
//                         bottom: -10,
//                         right: -10,
//                         child: IconButton(onPressed: (){}, icon: const Icon(Icons.add_a_photo),
//                       ),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 16,),
//                 Expanded(
//                   child: custum_text_field(
//                     Hinttext: 'Enter Group Name',
//                     controller: Gnamcon,
//                     icon: Icons.group,//Iconsax.user_tag
//                     lable: "Group Name",
//                   ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 15),
//             const Divider(),
//             Row(
//               children: [
//                 const Text('Mempers'),
//                 const Spacer(),
//                 Text(members.length.toString()),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(child: StreamBuilder(
//                 stream: FirebaseFirestore.instance.collection('users').
//                 doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
//
//                 builder: (context, snapshot) {
//                   if(snapshot.hasData)
//                   {
//                     myContacts = snapshot.data!.data()!['my_users'];
//
//                     return StreamBuilder(
//                       stream: FirebaseFirestore.instance.collection('users').
//                       where('id',whereIn: myContacts.isEmpty ? [''] : myContacts).snapshots(),
//                       //عايزين هنا بدل ما نحط ['']المفروض تتغير علشان بتطلع null
//                       builder: (context, snapshot) {
//                         if(snapshot.hasData)
//                         {
//                           final List<ChatUser> items = snapshot.data!.docs.map(
//                                   (e) => ChatUser.fromjson(e.data())
//                           ).where((element) => element.id != FirebaseAuth.instance.currentUser!.uid).toList()..sort((a, b) => a.name!.compareTo(b.name!),);
//                           return ListView.builder(
//                             itemCount: items.length,
//                             itemBuilder: (context, index) {
//                               return
//                                 CheckboxListTile(
//                                           title: Text(items[index].name!),
//                                           checkboxShape: const CircleBorder(),
//                                           value: members.contains(items[index].id),
//                                           onChanged: (value) {
//                                             setState(() {
//                                               if(value!){
//                                                 members.add(items[index].id!);
//                                               }
//                                               else{
//                                                 members.remove(items[index].id!);
//                                               }
//                                             });
//                                           },
//                                         );
//                             },
//                           );
//                         }
//                         else{
//                           return Container();
//                         }
//                       },
//                     );
//                   }
//                   else{
//                     return Container();
//                   }
//
//                 }
//
//
//             ),),
//             // Expanded(
//             //   child: ListView(
//             //     children: [
//             //       CheckboxListTile(
//             //         title: Text('Kero'),
//             //         checkboxShape: CircleBorder(),
//             //         value: true,
//             //         onChanged: (value) {
//             //
//             //       },
//             //       ),
//             //       CheckboxListTile(
//             //         checkboxShape: CircleBorder(),
//             //         title: Text('Karamela'),
//             //         value: false,
//             //         onChanged: (value) {
//             //
//             //         },
//             //       ),
//             //       CheckboxListTile(
//             //         checkboxShape: CircleBorder(),
//             //         title: Text('Amr Vikings'),
//             //         value: false,
//             //         onChanged: (value) {
//             //
//             //         },
//             //       ),
//             //       CheckboxListTile(
//             //         checkboxShape: CircleBorder(),
//             //         title: Text('Mostafa red dead redamption'),
//             //         value: false,
//             //         onChanged: (value) {
//             //
//             //         },
//             //       ),
//             //     ],
//             //   ),
//             // ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   //List<String> validContacts = myContacts.where((contact) => contact is String && contact.isNotEmpty).toList();
//
// }
//
