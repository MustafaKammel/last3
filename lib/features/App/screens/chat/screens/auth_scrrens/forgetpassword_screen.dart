
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../utill/colors.dart';
import '../../utill/custom_text_filed.dart';
import '../../utill/logoapp.dart';

class Reset_pass extends StatefulWidget {
  const Reset_pass({super.key});

  @override
  State<Reset_pass> createState() => _Reset_passState();
}

class _Reset_passState extends State<Reset_pass> {
  TextEditingController emailcon = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
      ),
      body:SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Container(
              //   height: 150,
              //  width: 150,
              //   decoration:  BoxDecoration(
              //     image: DecorationImage(image:AssetImage("assets/chat_image_com.jpg"),)
              //   ),
              // ),
              const logoapp(),
              const SizedBox(height: 20,),
              const Text("Reset password ",style: TextStyle(fontSize: 35),),
              const SizedBox(height: 10,),
              const  Text("Please enter your email ",style: TextStyle(fontSize: 15),),


              custum_text_field(
                lable: "Email",
                Hinttext: "Enter your email",
                icon: Iconsax.direct,
                controller: emailcon,
              ),


              const SizedBox(height: 15),
              ElevatedButton(onPressed: () async
              {
               await FirebaseAuth.instance.sendPasswordResetEmail(email: emailcon.text).then(
                      (value) {
                        Navigator.pop(context);
                        return ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('email sent check your email'),),);
                      } ,).onError(
                      (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(error.toString(),),
                  ),
                ),);

              },
                style: ElevatedButton.styleFrom(backgroundColor: kprimary),
                child:const Center(child: Text(" SEND EMAIL ",style: TextStyle(color: Colors.black87),)
                ),
              ),


            ],
          ),
        ),
      ) ,
    );

  }

}
