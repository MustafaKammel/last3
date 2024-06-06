import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

// import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import '../../firebase/fire_database.dart';
import '../../models/user_model.dart';
import '../../provider/provider.dart';
import '../../settings/Qrcodescreen.dart';
import '../../settings/profile.dart';

class SettingHomeScreen extends StatefulWidget {
  const SettingHomeScreen({super.key});

  @override
  State<SettingHomeScreen> createState() => _SettingHomeScreenState();
}

class _SettingHomeScreenState extends State<SettingHomeScreen> {
  bool dark_mood = true;

  late final ChatUser user;

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<providerApp>(context);
    return Scaffold(
      // floatingActionButton: FloatingActionButton(onPressed: ()
      // {
      //   FireData().sendNotification(chatUser: prov.me!, context: context, msg: "msg");
      // }
      // ),

      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ListTile(
                minVerticalPadding: 40,
                leading: CircleAvatar(radius: 30),
                title: Text(prov.me!.name.toString()),
                trailing: IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const QrcodeScreen(),
                      ),
                    );
                  },
                  icon: const Icon(Iconsax.scan_barcode),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Profile'),
                  leading: const Icon(Iconsax.user),
                  trailing: const Icon(Iconsax.arrow_right),
                  onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ProfileScreen(),
                      )),
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Theme'),
                  leading: const Icon(Iconsax.color_swatch),
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: SingleChildScrollView(
                            child: BlockPicker(
                              pickerColor: Color(prov.mainColor),
                              onColorChanged: (value) {
                                prov.changeColor(value.value);
                              },
                            ),
                          ),
                          actions: [
                            ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('Done'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
              Card(
                child: ListTile(
                  title: const Text('Dark Mood'),
                  // leading: Icon(Icons.dark_mode),
                  trailing:
                      // IconButton(onPressed: (){
                      //   context.read<ThemeCubit>().toggleTheme();
                      //
                      // }, icon: Icon(Icons.dark_mode)),
                      Switch(
                    value: prov.themeMode == ThemeMode.dark,
                    onChanged: (value) {
                      prov.ChangeMode(value);
                      print(value);
                      //final prov = Provider.of<providerApp>(context); define prov
                    },
                  ),
                ),
              ),
              // Card(
              //   child: ListTile(
              //     onTap: ()async => await FirebaseAuth.instance.signOut().then((value) {
              //       providerApp().signout_removed();
              //     }),
              //     title: const Text('Sign out'),
              //     trailing: const Icon(Iconsax.logout_1),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
