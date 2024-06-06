import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/authentication/screens/login/login_view.dart';

class OnBoardingController extends GetxController {
  static OnBoardingController get instance => Get.find();

  // variables
  final pageController = PageController();
  int currentPageIndex = 0;

  //update current index when page scroll
  void updatePageIndictor(index) => currentPageIndex = index;

  // jump to spasificdot selected page
  void dotNavigationClick(index) {
    currentPageIndex = index;
    pageController.jumpTo(index);
  }

  // update current index and jump to next page
  void nextPage() {
    if (currentPageIndex == 2) {
      // final storage = GetStorage();

      // if (kDebugMode) {
      //   print("=============== GetStorage ===============");
      //   print(storage.read('IsFirstTime'));
      // }

      // storage.write('IsFirstTime', false);

      // if (kDebugMode) {
      //   print("=============== GetStorage ===============");
      //   print(storage.read('IsFirstTime'));
      // }

      Get.offAll(const LoginView());
    } else {
      int page = currentPageIndex + 1;
      pageController.jumpToPage(page);
    }
  }

  // update current index and jump to last page
  void skipPage() {
    currentPageIndex = 2;
    pageController.jumpToPage(2);
  }
}
