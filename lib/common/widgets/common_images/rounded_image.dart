import 'package:flutter/material.dart';

import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';

class RoundedImage extends StatelessWidget {
  const RoundedImage({
    super.key,
    this.border,
    this.padding,
    this.onpress,
    this.width,
    this.height,
    this.applyImageRadius = true,
    required this.imagUrl,
    this.fit = BoxFit.contain,
    this.backGroundColor = MColors.light,
    this.isNetworkImage = false,
    this.borderRaduis = TSizes.md,
  });

  final double? width, height;
  final String imagUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color backGroundColor;
  final BoxFit fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onpress;
  final double borderRaduis;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onpress,
      child: Container(
        width: width,
        height: height,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backGroundColor,
          borderRadius: BorderRadius.circular(borderRaduis),
        ),
        child: ClipRRect(
          borderRadius: applyImageRadius
              ? BorderRadius.circular(TSizes.md)
              : BorderRadius.zero,
          child: Image(
            image: isNetworkImage
                ? NetworkImage(imagUrl)
                : AssetImage(imagUrl) as ImageProvider,
            fit: fit,
          ),
        ),
      ),
    );
  }
}
