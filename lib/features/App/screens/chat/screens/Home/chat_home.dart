

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';

import '../../Chat/widgets/Chat_card.dart';
import '../../firebase/fire_database.dart';
import '../../models/room_model.dart';
import '../../utill/custom_text_filed.dart';

class ChatHomeScreen extends StatefulWidget {
  const ChatHomeScreen({super.key});

  @override
  State<ChatHomeScreen> createState() => _ChatHomeScreenState();
}

class _ChatHomeScreenState extends State<ChatHomeScreen> {
  TextEditingController emailcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      floatingActionButton: FloatingActionButton(
          onPressed: (){
            showBottomSheet(context: context,
                builder: (context) {
                  return Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            const Text("Enter your Doctor email ",style: TextStyle(fontSize: 16)),
                            const Spacer(),
                            IconButton.filled(onPressed: (){}, icon: const Icon(Iconsax.scan_barcode)),
                          ],
                        ),
                        custum_text_field(
                          lable: "Email",
                          icon: Iconsax.direct,
                            controller: emailcontroller,
                            Hinttext: ' Enter the email ',
                        ),
                        ElevatedButton(
                          onPressed: (){
                            if(emailcontroller.text.isNotEmpty){
                              FireData().createRoom(emailcontroller.text).then(
                                      (value){
                                        setState(() {
                                          emailcontroller.text="";
                                        });
                                        Navigator.pop(context);
                                      });

                            }
                            else{
                              Fluttertoast.showToast(msg: "Enter the email");
                            }


                          },
                          style: ElevatedButton.styleFrom(
                          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                            padding: const EdgeInsets.symmetric(vertical:15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                        ),
                          child: const Center(child: Text('create chat'),),
                        ),
                      ],
                    ),
                  );
                },
            );
          },
        child: const Icon(Iconsax.message_add),
      ),

      body:  Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            
            Expanded(
              child:

              StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                stream: FirebaseFirestore.instance.collection('rooms')
                    .where('members', arrayContains: FirebaseAuth.instance.currentUser!.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  print(FirebaseAuth.instance.currentUser!.uid+"=========================++");
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Error: ${snapshot.error}'),
                    );
                  }

                  // if (snapshot.connectionState == ConnectionState.waiting) {
                  //   return Center(
                  //     child: CircularProgressIndicator(
                  //       backgroundColor: Theme.of(context).colorScheme.onBackground,
                  //     ),
                  //   );
                  // }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Center(
                      child: Text('No data available'),
                    );
                  }

                  List<ChatRoom> items = snapshot.data!.docs.map(
                          (e) => ChatRoom.fromjson(e.data())).toList()
                    ..sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!));

                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      return Chat_Card(
                        item: items[index],
                      );
                    },
                  );
                },
              ),


            ),

          ],
        ),
      ),
    );
  }
}





// StreamBuilder(
// stream: FirebaseFirestore.instance.collection('rooms').
// where('members',arrayContains: FirebaseAuth.instance.currentUser!.uid).
// snapshots(),
// builder: (context, snapshot) {
// if(snapshot.hasData){
// List<ChatRoom> items = snapshot.data!.docs.map(
// (e) => ChatRoom.fromjson(e.data())).toList()..
// sort((a, b) => b.lastMessageTime!.compareTo(a.lastMessageTime!),);
// return ListView.builder(
// itemCount: items.length,//snapshot.data!.docs.length
// itemBuilder: (context, index) {
// return Chat_Card(
// item: items[index],
// );
// },
// );
// }
// else{
// return Center(
// child: CircularProgressIndicator(
// backgroundColor: Theme.of(context).colorScheme.onBackground,
// ),
// );
// }
//
// }
// )