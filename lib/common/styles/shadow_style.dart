import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/colors.dart';


class ShadowStyle {
  
  static final verticalDoctorShadow = BoxShadow(
    color: MColors.darkGrey.withOpacity(0.1),
    blurRadius: 10,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );

  static final horizontalDoctorShadow = BoxShadow(
    color: MColors.darkGrey.withOpacity(0.1),
    blurRadius: 10,
    spreadRadius: 7,
    offset: const Offset(0, 2)
  );
}
