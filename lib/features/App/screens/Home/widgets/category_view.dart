import 'package:get/get.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:graduateproject/features/App/screens/Home/widgets/category_details_view.dart';

import '../../../../../common/widgets/app_bar/appbar.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class CategoryView extends StatelessWidget {
  const CategoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: false,
        title: Text(
          category,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      // appBar: AppBar(
      //   elevation: 0.0,
      //   backgroundColor: AppColor.blue,
      //   title: AppStyle.bold(
      //       title: category, size: 18, color: AppColor.whiteColor),
      // ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          physics: const BouncingScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 8,
            mainAxisSpacing: 8,
            mainAxisExtent: 170,
          ),
          itemCount: icons.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Get.to(
                  () => CategoryDetailsView(
                    catName: text[index],
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: dark ? MColors.grey : MColors.darkerGrey,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Image.asset(
                          icons[index],
                          width: 60,
                          color: dark ? MColors.darkerGrey : MColors.grey,
                        )),
                    30.heightBox,
                    AppStyle.bold(
                        title: text[index],
                        color: dark ? MColors.black : MColors.white,
                        size: 16),
                    10.heightBox,
                    AppStyle.normal(
                        title: "13 specialists",
                        color: dark
                            ? MColors.black.withOpacity(0.5)
                            : MColors.white.withOpacity(0.5),
                        //color: AppColor.whiteColor.withOpacity(0.5),
                        size: 12),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
