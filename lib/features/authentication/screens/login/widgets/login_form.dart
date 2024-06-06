import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:graduateproject/features/authentication/controllers/auth_controller.dart';
import 'package:graduateproject/navigation_menu.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/constants/text_strings.dart';
import 'package:graduateproject/features/authentication/screens/signUp/signup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../App/screens/Schedule/views/upcoming_schedule.dart';
import '../../password_forget/password_forget.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  var isDoctor = false;
  bool switchActivated = false;
  bool passwordVisible = false;
  bool rememberMe = false; // إضافة خاصية "Remember Me"
  var controller = Get.put(AuthController());
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void initState() {
    super.initState();
    loadSavedData(); // تحميل البيانات المخزنة عند بدء تشغيل التطبيق
  }

  void loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedEmail = prefs.getString('email');
    final savedIsDoctor = prefs.getBool('isDoctor');
    final savedSwitchActivated = prefs.getBool('switchActivated');

    if (savedEmail != null) {
      setState(() {
        controller.emailController.text = savedEmail;
        isDoctor = savedIsDoctor ?? false;
        switchActivated = savedIsDoctor ?? false;
        rememberMe = true; // تحديد مربع الاختيار "Remember Me"
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              keyboardType: TextInputType.emailAddress,
              controller: controller.emailController,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.email,
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Email is required.';
                }
                final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                if (!emailRegExp.hasMatch(value)) {
                  return 'Invalid email address.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            TextFormField(
              keyboardType: TextInputType.visiblePassword,
              controller: controller.passwordController,
              obscureText: !passwordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible ? Iconsax.eye_slash : Iconsax.eye),
                  onPressed: () {
                    setState(() {
                      passwordVisible = !passwordVisible;
                    });
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Password is required.';
                }
                return null;
              },
            ),
            const SizedBox(
              height: TSizes.spaceBtwInputFields,
            ),
            SwitchListTile(
              value: isDoctor,
              onChanged: (newValue) {
                setState(() {
                  isDoctor = newValue;
                  switchActivated = newValue;
                });
              },
              title: const Text("Sign in as a Doctor"),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Checkbox(
                      value: rememberMe,
                      onChanged: (value) {
                        setState(() {
                          rememberMe = value ?? false;
                        });
                      },
                    ),
                    const Text(TTexts.rememberMe),
                  ],
                ),
                TextButton(
                  onPressed: () {
                    Get.to(() => const ForgetPassword());
                  },
                  child: const Text(TTexts.forgetPassword),
                ),
              ],
            ),
            const SizedBox(
              height: TSizes.lg,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final emailExists = await checkIfEmailExists(controller.emailController.text);
                    if (emailExists && !switchActivated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "You must sign in as a doctor. Please activate the 'Sign in as a Doctor' switch."),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    if (!emailExists && switchActivated) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                              "You are a Patient, You must disable the enable switch"),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }
                    await controller.loginUser(isDoctor);
                    if (controller.userCredential != null) {
                      if (isDoctor || (!isDoctor && switchActivated)) { // Added condition here
                        Get.offAll(() => Upcomingschedule());
                      } else {
                        Get.offAll(() => const NavigationMenu());
                      }
                      controller.clearControllers();

                      if (rememberMe) { // تحقق مما إذا كانت خاصية "Remember Me" مُفعلة
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setString('email', controller.emailController.text);
                        prefs.setBool('isDoctor', isDoctor);
                        prefs.setBool('switchActivated', switchActivated);
                      }
                    }
                  }
                },
                child: const Text(TTexts.signIn),
              ),
            ),
            const SizedBox(
              height: TSizes.lg,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  Get.to(() => const SignUpView());
                },
                child: const Text(TTexts.createAccount),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<bool> checkIfEmailExists(String email) async {
    final querySnapshot = await _firestore
        .collection('doctors')
        .where('docEmail', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty;
  }
}
