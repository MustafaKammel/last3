import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/sizes.dart';


import 'widgets/customv_ertical_cancel_card.dart';

class Canceledschedule extends StatelessWidget {
  const Canceledschedule({super.key});
  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CustomVerticalCancelCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCancelCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCancelCard(),
          SizedBox(height: TSizes.spaceBtwItems),
          CustomVerticalCancelCard(),
          SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
