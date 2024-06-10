import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/common/styles/spacing_styles.dart';
import 'package:graduateproject/common/widgets/widgets_login_signup/form_divider.dart';
import 'package:graduateproject/common/widgets/widgets_login_signup/social_buttons.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/constants/text_strings.dart';
import 'package:graduateproject/features/authentication/screens/login/widgets/login_form.dart';
import 'package:graduateproject/features/authentication/screens/login/widgets/login_header.dart';
import 'package:lottie/lottie.dart';

import '../../controllers/auth_controller.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  var isDoctor = false;

  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());

    return Scaffold(
      body: Stack(
        children: [
          AnimatedBackground(),
          Container(
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Padding(
                padding: MSpacingStyle.paddingWithAppBarHeight,
                child: Column(
                  children: [
                    //Header
                    const LoginHeader(),

                    //Form
                    const LoginForm(),

                    //Divider
                    // FormDivider(dividerText: TTexts.orSignInWith.capitalize!),
                    //
                    // const SizedBox(height: TSizes.spaceBtwItems),

                    //Footer
                    // const SocialButtons(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AnimatedBackground extends StatelessWidget {
  const AnimatedBackground({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
      child: Lottie.asset(
        'assets/Animations/bg2.json',
        fit: BoxFit.cover,
      ),
    );
  }
}
