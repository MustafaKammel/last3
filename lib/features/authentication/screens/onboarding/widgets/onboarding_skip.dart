import 'package:flutter/material.dart';

import '../../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../../utils/device/device_utility.dart';
import '../../../controllers/onboarding_controller.dart';

class OnboardingSkip extends StatelessWidget {
  const OnboardingSkip({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(
        child: const Text("Skip"),
        onPressed: () => OnBoardingController.instance.skipPage(),
      ),
    );
  }
}
