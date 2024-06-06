import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class SettingController extends GetxController {
  @override
  void onInit() {
    // Check if there is a currently authenticated user
    if (FirebaseAuth.instance.currentUser != null) {
      getData = getUserData();
    }
    super.onInit();
  }

  var isLoading = false.obs;
  var currentUser = FirebaseAuth.instance.currentUser;
  var username = ''.obs;
  var email = ''.obs;
  Future? getData;

  getUserData() async {
    isLoading(true);
    DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
        .instance
        .collection('users')
        .doc(currentUser!.uid)
        .get();
    var userData = user.data();
    username.value = userData!['name'] ?? '';
    email.value = currentUser!.email ?? '';
    isLoading(false);
  }
}


// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:get/get.dart';

// class SettingController extends GetxController {
//   @override
//   void onInit() {
//     getData = getUserData();
//     super.onInit();
//   }

//   var isLoading = false.obs;
//   var currentUser = FirebaseAuth.instance.currentUser;
//   var username = ''.obs;
//   var email = ''.obs;
//   Future? getData;

//   getUserData() async {
//     isLoading(true);
//     DocumentSnapshot<Map<String, dynamic>> user = await FirebaseFirestore
//         .instance
//         .collection('users')
//         .doc(currentUser!.uid)
//         .get();
//     var userData = user.data();
//     username.value = userData!['name'] ?? '';
//     email.value = currentUser!.email ?? '';
//     isLoading(false);
//   }
// }
