import 'package:get/get.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';

class Tloaders {
  static hideSnackBar() =>
      ScaffoldMessenger.of(Get.context!).hideCurrentMaterialBanner();
  static customToast({required message}) {
    ScaffoldMessenger.of(Get.context!).showSnackBar(
      SnackBar(
        content: Container(
          padding: EdgeInsets.all(12.0),
          margin: EdgeInsets.symmetric(horizontal: 30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(300),
            color: THelperFunctions.isDarkMode(Get.context!)
                ? Colors.grey
                : Colors.red,
          ),
          child: Center(
            child: Text(
              message,
              style: Theme.of(Get.context!).textTheme.labelLarge,
            ),
          ),
        ),
      ),
    );
  }
}
