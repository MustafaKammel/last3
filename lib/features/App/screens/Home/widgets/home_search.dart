import 'package:get/get.dart';
import 'package:graduateproject/features/App/screens/Home/widgets/search_view.dart';
import 'package:graduateproject/features/authentication/controllers/home_controller.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/device/device_utility.dart';

class SearchHomePage extends StatelessWidget {
  const SearchHomePage(
      {super.key,
      required this.text,
      this.icon = Iconsax.search_normal,
      this.showBackground = true,
      this.showBorder = true});

  final String text;
  final IconData? icon;
  final bool showBackground, showBorder;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());
    final dark = THelperFunctions.isDarkMode(context);
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: TSizes.defaultSpace,
      ),
      child: Container(
        height: 78.0,
        width: TDeviceUtils.getScreenWidth(context),
        padding: const EdgeInsets.all(TSizes.md),
        decoration: BoxDecoration(
          color: showBackground
              ? dark
                  ? MColors.dark
                  : MColors.white
              : Colors.transparent,
          borderRadius: BorderRadius.circular(TSizes.cardRadiusLg),
          border: showBorder ? Border.all(color: MColors.grey) : null,
        ),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: controller.searchQueryController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Iconsax.search_favorite),
                  hintStyle:
                      const TextStyle(fontSize: 14, color: MColors.darkGrey),
                  labelText: text,
                ),
              ),
            ),
            10.widthBox,
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: dark ? MColors.white : MColors.primaryBackground),
              child: IconButton(
                  onPressed: () {
                    Get.to(() => SearchView(
                          searchQuery: controller.searchQueryController.text,
                        ));
                  },
                  icon: const Icon(
                    Icons.search,
                    color: MColors.dark,
                    size: 30,
                  )),
            )
          ],
        ),
      ),
    );
  }
}
