import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:graduateproject/features/App/screens/Favorite/favorite_page.dart';
import 'package:graduateproject/features/App/screens/Home/home_page.dart';
import 'package:graduateproject/features/App/screens/Home/widgets/category_view.dart';
// import 'package:graduateproject/features/App/screens/chat/chat_screens.dart';
import 'package:graduateproject/features/personalization/screens/settings/settings_view.dart';
import 'package:iconsax/iconsax.dart';

import 'features/App/screens/Schedule/views/upcoming_schedule.dart';
import 'features/App/screens/chat/ChatScreens.dart';

class NavigationMenu extends StatefulWidget {
  const NavigationMenu({super.key});

  @override
  State<NavigationMenu> createState() => _NavigationMenuState();
}

class _NavigationMenuState extends State<NavigationMenu> {
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
            NavigationDestination(icon: Icon(Iconsax.home), label: 'home'),
            NavigationDestination(icon: Icon(Iconsax.book), label: 'schedule'),
            NavigationDestination(
                icon: Icon(Iconsax.category), label: 'Category'),
            NavigationDestination(icon: Icon(Iconsax.message), label: 'chat'),
            NavigationDestination(icon: Icon(Iconsax.heart), label: 'favorite'),
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
     HomePage(),
    //const AppointmentView(),
     Upcomingschedule(),
    const CategoryView(),
    const ChatScreens(),
    const FavoriteScreen(),
    const SettigsView(),
  ];
}
