import 'package:flutter/material.dart';

import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../../../../utils/helpers/helper_functions.dart';

class TermsAndConditionsCheckBox extends StatelessWidget {
  const TermsAndConditionsCheckBox({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Row(
      children: [
        SizedBox(
          width: 24,
          height: 24,
          child: Checkbox(value: true, onChanged: (value) {}),
        ),
        const SizedBox(
          width: TSizes.spaceBtwItems,
        ),
        Text.rich(
          TextSpan(children: [
            TextSpan(
                text: '${TTexts.iAgreeTo} ',
                style: Theme.of(context).textTheme.labelSmall),
            TextSpan(
              text: '${TTexts.privacyPolicy} ',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: dark ? MColors.white : MColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? MColors.white : MColors.primary,
                  ),
            ),
            TextSpan(
              text: '${"and"} ',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            TextSpan(
              text: '${TTexts.termsOfUse} ',
              style: Theme.of(context).textTheme.labelSmall!.apply(
                    color: dark ? MColors.white : MColors.primary,
                    decoration: TextDecoration.underline,
                    decorationColor: dark ? MColors.white : MColors.primary,
                  ),
            ),
          ]),
        ),
      ],
    );
  }
}
