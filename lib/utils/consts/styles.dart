import 'package:graduateproject/utils/consts/consts.dart';

class AppFonts {
  static String regular = "sans_regular";
  static String semibold = "sans_semibold";
  static String bold = "sans_bold";
}

class AppStyle {
  static normal(
      {String? title,
      Color? color = Colors.black,
      double? size = 14,
      TextAlign align = TextAlign.left}) {
    return title!.text.size(size).color(color).align(align).make();
  }

  static bold(
      {String? title,
      Color? color = Colors.black,
      double? size = 14,
      TextAlign align = TextAlign.left}) {
    return title!.text
        .size(size)
        .color(color)
        .fontFamily(AppFonts.bold)
        .align(align)
        .make();
  }
}
