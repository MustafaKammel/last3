// import 'package:chat_udemy/Contact/contact_card.dart';
// import 'package:chat_udemy/firebase/fire_database.dart';
// import 'package:chat_udemy/models/user_model.dart';
// import 'package:chat_udemy/utill/custom_text_filed.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:iconsax/iconsax.dart';
//
// class ContactsHomeScreen extends StatefulWidget {
//   const ContactsHomeScreen({super.key});
//
//   @override
//   State<ContactsHomeScreen> createState() => _ContactsHomeScreenState();
// }
//
// class _ContactsHomeScreenState extends State<ContactsHomeScreen> {
//   bool searched =false;
//   List myContacts = [];
//
//   TextEditingController emailcontroller = TextEditingController();
//   TextEditingController searchcontroller = TextEditingController();
//
//   // getMyContacts() async {
//   //   final contact = await FirebaseFirestore.instance.
//   //   collection('users').
//   //   doc(FirebaseAuth.instance.currentUser!.uid).get().
//   //   then((value) => myContacts = value.data()!['my_users']);
//   //   print(myContacts);
//   // }
//   //
//   // @override
//   // void initState() {
//   //   getMyContacts();
//   //   super.initState();
//   // }
//   @override
//   Widget build(BuildContext context) {
//     return  Scaffold(
//       appBar: AppBar(
//         actions: [searched ?
//         IconButton(
//           onPressed: (){
//             setState(() {
//               searched=false;
//               searchcontroller.text = "";
//             });
//           },
//
//           icon: const Icon(Iconsax.close_circle),) :
//            IconButton(onPressed: (){
//              setState(() {
//                searched=true;
//              });
//            },
//              icon: const Icon(Iconsax.search_normal),)
//       ],
//         title: searched ?Row(children: [
//           Expanded(
//               child: TextField(
//                 autofocus: true,
//                 onChanged: (value) {
//                   setState(() {
//                     searchcontroller.text = value;
//                   });
//                 },
//                 controller: searchcontroller,
//                 decoration: const InputDecoration(
//                     border: InputBorder.none,
//                     hintText: 'Search by name'
//                 ),
//               ),
//           ),
//         ],) :const Text("My Contacts"),
//
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: (){
//           showBottomSheet(context: context,
//             builder: (context) {
//               return Container(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Row(
//                       children: [
//                         const Text("Enter your friend email 😘",style: TextStyle(fontSize: 16)),
//                         const Spacer(),
//                         IconButton.filled(onPressed: (){}, icon: const Icon(Iconsax.scan_barcode)),
//                       ],
//                     ),
//                     custum_text_field(
//                       lable: "Email",
//                       icon: Iconsax.direct,
//                       controller: emailcontroller,
//                       Hinttext: ' Enter the email ',
//                     ),
//                     ElevatedButton(
//                       onPressed: (){
//                         FireData().addContact(emailcontroller.text).then((value)
//                         {
//                           setState(() {
//                             emailcontroller.text = "";
//                           });
//                           Navigator.pop(context);
//                         });
//                       },
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Theme.of(context).colorScheme.primaryContainer,
//                         padding: const EdgeInsets.symmetric(vertical:15),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(12),
//                         ),
//                       ),
//                       child: const Center(child: Text('Add Contact'),),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           );
//         },
//         child: const Icon(Iconsax.user_add),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           children: [
//             Expanded(
//               child:
//
//
//               StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
//                 stream: FirebaseFirestore.instance.collection('users')
//                     .doc(FirebaseAuth.instance.currentUser!.uid)
//                     .snapshots(),
//                 builder: (context, snapshot) {
//                   if (snapshot.hasData) {
//                     myContacts = snapshot.data!.data()?['my_users'] ?? []; // Ensure myContacts is never null
//
//                     return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
//                       stream: myContacts.isEmpty
//                           ? Stream<QuerySnapshot<Map<String, dynamic>>>.empty()
//                           : FirebaseFirestore.instance.collection('users')
//                           .where('id', whereIn: myContacts)
//                           .snapshots(),
//                       builder: (context, snapshot) {
//                         if (snapshot.hasData) {
//                           final List<ChatUser> items = snapshot.data!.docs
//                               .map((e) => ChatUser.fromjson(e.data()))
//                               .where((element) =>
//                               element.name!.toLowerCase().contains(searchcontroller.text.toLowerCase())
//                           )
//                               .toList()
//                             ..sort((a, b) => a.name!.compareTo(b.name!));
//
//                           return ListView.builder(
//                             itemCount: items.length,
//                             itemBuilder: (context, index) {
//                               return Contact_Card(
//                                 user: items[index],
//                               );
//                             },
//                           );
//                         } else {
//                           return Container();
//                         }
//                       },
//                     );
//                   } else {
//                     return Container();
//                   }
//                 },
//               ),
//
//
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
// // StreamBuilder(
// // stream: FirebaseFirestore.instance.collection('users').
// // doc(FirebaseAuth.instance.currentUser!.uid).snapshots(),
// //
// // builder: (context, snapshot) {
// // if(snapshot.hasData)
// // {
// // myContacts = snapshot.data!.data()!['my_users'];
// //
// // return StreamBuilder(
// // stream: FirebaseFirestore.instance.collection('users').
// // where('id',whereIn: myContacts.isEmpty ? [''] : myContacts).snapshots(),
// // //عايزين هنا بدل ما نحط ['']المفروض تتغير علشان بتطلع null
// // builder: (context, snapshot) {
// // if(snapshot.hasData)
// // {
// // final List<ChatUser> items = snapshot.data!.docs.map(
// // (e) => ChatUser.fromjson(e.data())
// // ).where((element) => element.name!.toLowerCase().
// // contains(searchcontroller.text.toLowerCase()))
// //     .toList()..sort((a, b) => a.name!.compareTo(b.name!),);
// // return ListView.builder(
// // itemCount: items.length,
// // itemBuilder: (context, index) {
// // return Contact_Card(
// // user: items[index],
// // );
// // },
// // );
// // }
// // else{
// // return Container();
// // }
// // },
// // );
// // }
// // else{
// // return Container();
// // }
// //
// // }
// //
// //
// // ),