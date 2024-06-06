import 'package:flutter/material.dart';


class SectionHeading extends StatelessWidget {
  const SectionHeading(
      {super.key,
      this.textColor,
      this.showActionButton = true,
      required this.title,
      this.buttonTitle = "View all",
      this.onpress});

  final Color? textColor;
  final bool showActionButton;
  final String title, buttonTitle;
  final void Function()? onpress;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: Theme.of(context)
              .textTheme
              .headlineSmall!
              .apply(color: textColor),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        if (showActionButton)
          TextButton(
            onPressed: onpress,
            child: Text(
              buttonTitle,
            ),
          ),
      ],
    );
  }
}
