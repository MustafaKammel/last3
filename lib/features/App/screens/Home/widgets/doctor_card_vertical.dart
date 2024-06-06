import 'package:flutter/material.dart';
import 'package:graduateproject/common/styles/shadow_style.dart';
import 'package:graduateproject/common/widgets/common_images/rounded_image.dart';
import 'package:graduateproject/common/widgets/custom_shapes/contianers/rounded_container.dart';
import 'package:graduateproject/common/widgets/texts/doctor_title_text.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';


class DoctorCardVertical extends StatelessWidget {
  const DoctorCardVertical({
    super.key,
    required this.title,
    required this.subtitle,
    required this.image,
    this.onTap,
  });
  final String title, subtitle, image;
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalDoctorShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? MColors.darkGrey : MColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.sm),
              backGroundColor: dark ? MColors.dark : MColors.grey,
              child: Stack(
                children: [
                  RoundedImage(
                    imagUrl: image,
                    applyImageRadius: true,
                    fit: BoxFit.fill,
                    height: 100,
                    width: double.infinity,
                  ),
                  Positioned(
                    top: -5,
                    right: -5,
                    child: IconButton(
                      icon: const Icon(
                        Iconsax.heart5,
                        color: Colors.red,
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorTitleText(
                    title: title,
                    smallSize: true,
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedContainer(
                        radius: TSizes.sm,
                        width: 60,
                        backGroundColor: MColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: TSizes.xs),
                        child: const Row(
                          children: [
                            Icon(
                              Iconsax.star,
                              size: 12,
                            ),
                            SizedBox(
                              width: TSizes.xs,
                            ),
                            Text(
                              "9.5",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: TSizes.iconLg * 1.2,
                        height: TSizes.iconLg * 1.2,
                        decoration: const BoxDecoration(
                          color: MColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                            bottomRight:
                                Radius.circular(TSizes.productImageRadius),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.add,
                            color: MColors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
