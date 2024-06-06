// ignore_for_file: unnecessary_null_comparison

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graduateproject/features/App/screens/chat/firebase/fire_auth.dart';
import 'package:graduateproject/navigation_menu.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:graduateproject/features/authentication/screens/login/login_view.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:graduateproject/views/doctor/doctor_navigationMenue/navigation_view.dart';

import '../../Onboboarding/onboarding_view.dart';

class AuthController extends GetxController {
  var fullnameController = TextEditingController();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  UserCredential? userCredential;
  final box = GetStorage();

  //Doctor Controllers
  var aboutController = TextEditingController();
  var addressController = TextEditingController();
  var servicesController = TextEditingController();
  var timingControllerfrom = TextEditingController();
  var timingControllerto = TextEditingController();
  var salaryController = TextEditingController();
  var phoneController = TextEditingController();
  var categoryController = TextEditingController();

  String categoryslected = 'Cardiolo';
  String dayslected = 'Monday';

  List<String> categoryList = [
    "Cardiolo", //أمراض القلب
    "Ophthalmology", //طب العيون
    "pulmonology", //أمراض الرئة
    "Dentist", //طبيب أسنان
    "Neurology", //علم الأعصاب
    "Orthopedic", //تقويم العظام
    "Nephrology", //أمراض الكلى
    "Otolaryngolgy",
    // Add more categories as needed
  ];

  static isUserAlreadyLoggedIn() async {
    FirebaseAuth.instance.authStateChanges().listen((User? user) async {
      if (user != null) {
        var data = await FirebaseFirestore.instance
            .collection('doctors')
            .doc(user.uid)
            .get();
        var isDoc = data.data()?.containsKey('docName') ?? false;
        if (isDoc) {
          Get.offAll(() => const Docnavigationmenu());
        } else {
          // await TlocalStorage.init(user.uid);
          Get.offAll(() => const NavigationMenu());
        }
      } else {
        Get.offAll(() => const LoginView());
      }
    });
  }

  Rx<User?> user = Rx<User?>(null);

  Future<void> loginUser(bool isdoctor) async {
    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      box.write('role', '${isdoctor == true ? "doctor" : "user"} ');
      emailController.clear();
      passwordController.clear();
    } catch (e) {
      String errorMessage =
          "An error occurred!!,Wrong password or No user found for that email.";
      if (e is FirebaseAuthException) {
        if (e.code == 'user-not-found') {
          errorMessage = "No user found for that email.";
        } else if (e.code == 'wrong-password') {
          errorMessage = "Wrong password provided for that user.";
        }
      }
      THelperFunctions.showSnackBar(errorMessage);
    }
  }

  signupUser(bool isDoctor, List<String> selectedDays) async {
    if (fullnameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      THelperFunctions.showSnackBar("Please fill in all fields");
      return;
    }

    // Add additional validation checks if necessary

    try {
      userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      await storeUserData(userCredential!.user!.uid, fullnameController.text,
          emailController.text, isDoctor, selectedDays);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'email-already-in-use') {
        THelperFunctions.showSnackBar("The email address is already in use");
      } else {
        THelperFunctions.showSnackBar("An error occurred during sign up");
      }
    } catch (e) {
      print('Error during sign up: $e');
      THelperFunctions.showSnackBar("An error occurred during sign up");
    }
  }

  Future resetPassword() async {
    try {
      await FirebaseAuth.instance
          .sendPasswordResetEmail(email: emailController.text.trim());
      THelperFunctions.showAlert(
          "Hi, ${emailController.text.trim()}", "Check your Email");
      //Get.off(() => const ResetPassword());
    } catch (e) {
      THelperFunctions.showSnackBar("couldnt sent you a message");
    }
  }

  storeUserData(String uid, String fullname, String email, bool isDoctor,
      List<String> availableDays) async {
    var store = FirebaseFirestore.instance
        .collection(isDoctor ? 'doctors' : 'users')
        .doc(uid);

    var store2 = FirebaseFirestore.instance.collection('users').doc(uid);
    if (isDoctor) {
      box.write('role', 'doctor');
      await store.set({
        'docAbout': aboutController.text,
        'docAddress': addressController.text,
        'docCategory': categoryslected,
        'docName': fullname,
        'docPhone': phoneController.text,
        'docService': servicesController.text,
        'docTimingfrom': timingControllerfrom.text,
        'docTimingto': timingControllerto.text,
        'docSalary': salaryController.text,
        'docId': FirebaseAuth.instance.currentUser?.uid,
        'docRating': 1,
        'docEmail': email,
        'availableDays': FieldValue.arrayUnion(availableDays),
        'isFavorite': false,
        'role': 'doctor',
        'docimage':'',
      });
    } else {
      box.write('role', 'user');
      await store.set({
        'name': fullname,
        'email': email,
        'id': uid,
        'about': 'i am new at this app',
        'image': '',
        'created_at': DateTime.now().toString(),
        'last_activated': DateTime.now().toString(),
        'puch_token': '',
        'online': false,
        'role': 'user',
      });
    }
  }

  signout() async {
    await FirebaseAuth.instance.signOut().then((value) {
      Get.offAll(() => const LoginView());
    }); //=> const LoginView()
    box.remove('role');
    print(
        '===========================${FirebaseAuth.instance.currentUser?.uid}==================================');
  }

  void clearControllers() {
    emailController.clear();
    passwordController.clear();
  }
}
