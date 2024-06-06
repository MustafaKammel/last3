// import 'package:chat_udemy/Chat/Chat_screen.dart';
// import 'package:chat_udemy/firebase/fire_database.dart';
// import 'package:chat_udemy/models/user_model.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:full_screen_image/full_screen_image.dart';
// import 'package:iconsax/iconsax.dart';
//
// class Contact_Card extends StatelessWidget {
//   const Contact_Card({super.key, required this.user});
// final ChatUser user;
//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       child: ListTile(
//         leading:user.image =="" ? FullScreenWidget(
//           disposeLevel: DisposeLevel.High,
//           child: const CircleAvatar(
//             backgroundImage: AssetImage("assets/chat_image_com.jpg"),
//           ),
//         ) : FullScreenWidget(
//             disposeLevel: DisposeLevel.High,
//         child: CircleAvatar(backgroundImage: NetworkImage(user.image!))),
//         title: Text(user.name!),
//         subtitle: Text(user.about!,maxLines: 1,),
//         trailing: IconButton(onPressed: (){
//           List<String> members = [user.id!, FirebaseAuth.instance.currentUser!.uid]..sort(
//             (a, b) => a.compareTo(b),
//           );
//           FireData().createRoom(user.email!).then((value) =>
//               Navigator.push(context, MaterialPageRoute(
//             builder: (context) => Chat_screen(roomId: members.toString(), chatUser: user),)));
//
//         }, icon: const Icon(Iconsax.message)),
//       ),
//     );
//   }
// }
