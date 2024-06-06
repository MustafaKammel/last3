import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:graduateproject/features/App/screens/chat/provider/provider.dart';
import 'package:provider/provider.dart';

import 'Layout.dart';
import 'screens/auth_scrrens/Name_screen.dart';
import 'screens/auth_scrrens/login.dart';

class ChatScreens extends StatelessWidget {
  const ChatScreens({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) =>providerApp(),
      child: Consumer<providerApp>(
        builder:(context,value,child) =>MaterialApp(
          themeMode:value.themeMode,
          title: 'Chat Now copy in D',
          theme: ThemeData(
            // brightness: Brightness.light,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color(value.mainColor),brightness: Brightness.light),
            useMaterial3: true,
          ),
          darkTheme: ThemeData(
            // brightness: Brightness.dark,
            colorScheme: ColorScheme.fromSeed(
                seedColor: Color(value.mainColor),brightness: Brightness.dark),
            useMaterial3: true,
          ),

          debugShowCheckedModeBanner: false,
          home: StreamBuilder(stream: FirebaseAuth.instance.userChanges(),//دي فيدة دي علشان لو كنت عامل تسجيل دخول قبل كدة وخرجت من الاب من غير تسجيل الخروج اول لما افتح الاب تاني هيفتح علي الصفحة الاساسية ولو عملت تسجيل الخروج لما اجي افتح الاب تاني هيفتح علي صفحة login دي فايدة stream
            builder: (context, snapshot) {
              if(snapshot.hasData) {
                if(FirebaseAuth.instance.currentUser!.displayName == "" ||
                    FirebaseAuth.instance.currentUser!.displayName == null  ){
                  return const Name_screen();
                }
                else{
                  return const LayoutApp();
                }

              }
              else{
                return const Login_chat();
              }

            },
          ),
        ),
      ),
    );
  }
}
