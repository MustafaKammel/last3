import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iconsax/iconsax.dart';
import 'package:provider/provider.dart';

import 'firebase/fire_auth.dart';
import 'models/user_model.dart';
import 'provider/provider.dart';
import 'screens/Home/Contacts.dart';
import 'screens/Home/GroupHomeScreen.dart';
import 'screens/Home/Setting.dart';
import 'screens/Home/chat_home.dart';

class LayoutApp extends StatefulWidget {
  const LayoutApp({super.key});

  @override
  State<LayoutApp> createState() => _LayoutAppState();
}

class _LayoutAppState extends State<LayoutApp> {
  int currentindex = 0;
  PageController pagecontroller = PageController();

  @override
  void initState() {
    Provider.of<providerApp>(context, listen: false).getValuesPref();
    Provider.of<providerApp>(context, listen: false).getUserDetails();
    SystemChannels.lifecycle.setMessageHandler((message) {
      if (message.toString() == 'AppLifecycleState.resumed') {
        FireAuth().updateActivated(true);
      } else if (message.toString() == 'AppLifecycleState.inactive' ||
          message.toString() == 'AppLifecycleState.paused') {
        FireAuth().updateActivated(false);
      }
      return Future.value(message);
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ChatUser? me = Provider.of<providerApp>(context).me;

    return Scaffold(
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60.0),
          child: NavigationBar(
            selectedIndex: currentindex,
            onDestinationSelected: (value) {
              setState(() {
                currentindex = value;
                pagecontroller.jumpToPage(value);
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Iconsax.message_2),
                label: "Chat",
              ),
              // NavigationDestination(
              //   icon: Icon(Iconsax.messages),
              //   label: "Groups",
              // ),
              // NavigationDestination(
              //   icon: Icon(Iconsax.user),
              //   label: "Contacts",
              // ),
              NavigationDestination(
                icon: Icon(Iconsax.setting),
                label: "Setting",
              ),
            ],
          ),
        ),
      ),
      body: me == null
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : PageView(
        onPageChanged: (value) {
          setState(() {
            currentindex = value;
          });
        },
        controller: pagecontroller,
        children: const [
          ChatHomeScreen(),
          // GroupHomeScreen(),
          // ContactsHomeScreen(),
          SettingHomeScreen(),
        ],
      ),
    );
  }
}
