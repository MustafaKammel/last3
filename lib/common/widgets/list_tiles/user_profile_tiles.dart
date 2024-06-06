import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/utils/constants/image_string.dart';
import 'package:iconsax/iconsax.dart';

import '../../../features/personalization/controllers/setting_controller.dart';
import '../common_images/circular_image.dart';
import '../../../utils/constants/colors.dart';

class UserProfileTitle extends StatelessWidget {
  const UserProfileTitle({super.key, this.onpress});
  final VoidCallback? onpress;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingController());
    return ListTile(
      leading: CircularImage(
          image: TImages.Profile, width: 50, height: 50, padding: 0),
      title: Text(controller.username.toString(),
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: MColors.white)),
      subtitle: Text(controller.email.toString(),
          style: Theme.of(context)
              .textTheme
              .labelMedium!
              .apply(color: MColors.white)),
      trailing: IconButton(
          onPressed: onpress,
          icon: const Icon(
            Iconsax.edit,
            color: MColors.white,
          )),
    );
  }
}
