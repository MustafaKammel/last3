import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/App/screens/chat/ChatScreens.dart';
import 'package:graduateproject/features/Notifications/notification_screen.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:graduateproject/views/doctor/doctor_views/doctor_booking.dart';
import 'package:graduateproject/views/doctor/doctor_views/doctor_chat.dart';
import 'package:graduateproject/views/doctor/doctor_views/doctor_settinges.dart';
import 'package:iconsax/iconsax.dart';

class Docnavigationmenu extends StatefulWidget {
  const Docnavigationmenu({super.key});

  @override
  State<Docnavigationmenu> createState() => _DocnavigationmenuState();
}

class _DocnavigationmenuState extends State<Docnavigationmenu> {
  int selectedIndex = 0;

  // List screanList = [
  //   const HomePage(),
  //   const AppointmentView(),
  //   const CategoryView(),
  //   const SettigsView(),
  // ];

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(NavigationController());
    final darkMode = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: Obx(() => controller.screens[controller.selectedIndex.value]),
      bottomNavigationBar: Obx(
        () => NavigationBar(
          height: 80,
          elevation: 0,
          selectedIndex: controller.selectedIndex.value,
          onDestinationSelected: (index) =>
              controller.selectedIndex.value = index,
          backgroundColor: darkMode ? MColors.black : MColors.white,
          indicatorColor: darkMode
              ? MColors.white.withOpacity(0.1)
              : MColors.black.withOpacity(0.1),
          destinations: const [
            NavigationDestination(icon: Icon(Iconsax.book), label: 'schedule'),
            NavigationDestination(icon: Icon(Iconsax.notification), label: 'notifications'),
            NavigationDestination(
                icon: Icon(Iconsax.message), label: 'chat'),
            NavigationDestination(icon: Icon(Iconsax.user), label: 'settings'),
          ],
        ),
      ),
    );
  }
}

class NavigationController extends GetxController {
  final Rx<int> selectedIndex = 0.obs;

  final screens = [
    const Doc_booking(),
    NotificationScreen(),
    const ChatScreens(),
    const Doc_Settings(),
  ];
}
