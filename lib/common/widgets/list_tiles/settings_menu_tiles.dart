import 'package:flutter/material.dart';
import 'package:graduateproject/utils/constants/colors.dart';

class SettingMenuTiles extends StatelessWidget {
  const SettingMenuTiles({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle="",
    this.trailing,
    this.ontap,
  });
  final IconData icon;
  final String title, subtitle;
  final Widget? trailing;
  final VoidCallback? ontap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        icon,
        size: 25,
        color: MColors.primary,
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium,
      ),
      subtitle: Text(
        subtitle,
        style: Theme.of(context).textTheme.labelMedium,
      ),
      trailing: trailing,
      onTap: ontap,
    );
  }
}
