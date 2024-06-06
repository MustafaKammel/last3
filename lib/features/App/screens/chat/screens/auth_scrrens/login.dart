
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

import '../../Layout.dart';
import '../../firebase/fire_auth.dart';
import '../../utill/colors.dart';
import '../../utill/custom_text_filed.dart';
import '../../utill/logoapp.dart';
import 'forgetpassword_screen.dart';

class Login_chat extends StatefulWidget {
  const Login_chat({super.key});

  @override
  State<Login_chat> createState() => _Login_chatState();
}

class _Login_chatState extends State<Login_chat> {
  TextEditingController emailcon = TextEditingController();
  TextEditingController passcon = TextEditingController();
  final formkey = GlobalKey<FormState>();
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
              const Text("Welcome back ",style: TextStyle(fontSize: 35),),
              const SizedBox(height: 10,),
              const  Text("How are you ?",style: TextStyle(fontSize: 15),),


              Form(
                key: formkey,
                child: Column(
                  children: [
                    custum_text_field(
                      lable: "Email",
                      Hinttext: "Enter the email",
                      icon: Iconsax.direct,
                      controller: emailcon,
                    ),

                    custum_text_field(
                      lable: "Password",
                      icon: Iconsax.password_check,
                      Hinttext: "Enter the password",
                      controller: passcon,
                      ispass: true,
                    ),

                    Row(
                      children: [
                        const Spacer(),
                        TextButton(onPressed:
                            (){
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const Reset_pass(),),);
                            },
                            child: const Text("Forget password ?"),
                        ),
                      ],
                    ),
                    const SizedBox(height: 15),
                    ElevatedButton(
                      onPressed: () async
                    {
                      if(formkey.currentState!.validate()){
                        await FirebaseAuth.instance.signInWithEmailAndPassword(email: emailcon.text, password: passcon.text).then(
                              (value) => Navigator.push(context, MaterialPageRoute(builder: (context) => const LayoutApp(),))).
                        onError(
                              (error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(error.toString(),),
                                  ),
                              ),
                        );
                      }
                      //             print("Done!");
                      //
                      // Navigator.push(
                      //   context, MaterialPageRoute(
                      //   builder: (context) => LayoutApp(),
                      //   ),
                      // );//ده زيادة علشان الشكل بس مؤقتا

                    },
                      style: ElevatedButton.styleFrom(backgroundColor: kprimary),
                        child:const Center(child: Text("LOGIN",style: TextStyle(color: Colors.black87),)
                        ),
                    ),
                    const  SizedBox(height: 10,),
                    OutlinedButton(
                        onPressed: () async {
                          // Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder:(context) =>Name_screen() ,), (route) => false);
                     await  FirebaseAuth.instance.createUserWithEmailAndPassword(
                         email: emailcon.text, password: passcon.text
                     ).then(
                             (value) => FireAuth.createuser(),
                     ).onError((error, stackTrace) => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.toString()))),);
                        },
                        style: OutlinedButton.styleFrom(

                        ),
                        child:const Center(child: Text(" Create Account ",),

                        ),
                    ),
                  ],
                ),
              ),

            ],
          ),
        ),
      ) ,
    );

  }

}
