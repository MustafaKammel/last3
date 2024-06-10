import 'package:get/get.dart';
import 'package:graduateproject/common/widgets/widgets_login_signup/form_divider.dart';
import 'package:graduateproject/common/widgets/widgets_login_signup/social_buttons.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/constants/text_strings.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:graduateproject/features/authentication/controllers/auth_controller.dart';
import 'package:graduateproject/features/authentication/screens/signUp/widgets/sign_up_form.dart';

class SignUpView extends StatefulWidget {
  const SignUpView({super.key});

  @override
  State<SignUpView> createState() => _SignUpViewState();
}

class _SignUpViewState extends State<SignUpView> {
  var isDoctor = false;
  @override
  Widget build(BuildContext context) {
    Get.put(AuthController());
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(TTexts.signupTitle,
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: TSizes.defaultSpace),
              //The Form
              const SignUpForm(),
              const SizedBox(height: TSizes.spaceBtwItems),
              // Form Divider
              // FormDivider(dividerText: TTexts.orSignUpWith.capitalize!),
              // const SizedBox(height: TSizes.spaceBtwItems),
              // Social Buttons
              // const SocialButtons(),


            ],
          ),
        ),
      ),
    );
  }
}
