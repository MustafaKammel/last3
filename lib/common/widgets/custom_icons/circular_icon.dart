import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/sizes.dart';


import '../../../utils/helpers/helper_functions.dart';

class CircularIcon extends StatelessWidget {
  const CircularIcon({
    super.key,
    required this.icon,
    this.width,
    this.height,
    this.size = TSizes.lg,
    this.color,
    this.backgroundColor,
    this.onpress,
  });
  final double? width, height, size;
  final IconData icon;
  final Color? color;
  final Color? backgroundColor;
  final VoidCallback? onpress;

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: backgroundColor != null
            ? backgroundColor!
            : dark
                ? Colors.transparent
                : Colors.transparent,
        borderRadius: BorderRadius.circular(100),
      ),
      child: IconButton(
        onPressed: onpress,
        icon: Icon(
          icon,
          color: color,
          size: size,
        ),
      ),
    );
  }
}
