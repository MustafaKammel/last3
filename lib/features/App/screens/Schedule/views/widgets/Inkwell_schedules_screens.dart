// ignore_for_file: file_names

import 'package:flutter/material.dart';

class CustomInkwellScheduleScreens extends StatelessWidget {
  const CustomInkwellScheduleScreens({
    super.key,
    this.onpress,
    required this.title,
    required this.backGroundColor,
    required this.textColor,
  });
  final VoidCallback? onpress;
  final String title;
  final Color backGroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onpress,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: backGroundColor,
          borderRadius: BorderRadius.circular(40),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: textColor,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
