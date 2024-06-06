import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';


class CircularImage extends StatelessWidget {
  const CircularImage({
    super.key,
    this.width = 56,
    this.height = 56,
    this.overlayColor,
    this.backGrounColor,
    required this.image,
    this.fit = BoxFit.cover,
    this.padding = TSizes.sm,
    this.isNetwork = false,
  });

  final BoxFit? fit;
  final String image;
  final bool isNetwork;
  final Color? overlayColor;
  final Color? backGrounColor;
  final double width, height, padding;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.all(padding),
      decoration: BoxDecoration(
          color: backGrounColor ?? (dark ? MColors.black : MColors.white),
          borderRadius: BorderRadius.circular(100)),
      child: Center(
        child: Image(
          fit: fit,
          image: isNetwork ? NetworkImage(image) : AssetImage(image) as ImageProvider,
          color: overlayColor,
        ),
      ),
    );
  }
}
