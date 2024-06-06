import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/sizes.dart';


import 'widgets/custom_vertical_completed_card.dart';

class Completedschedule extends StatelessWidget {
  const Completedschedule({super.key});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomVerticalCompletedCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCompletedCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCompletedCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCompletedCard(),
          SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
