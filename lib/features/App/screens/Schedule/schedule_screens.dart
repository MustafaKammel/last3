import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/common/widgets/app_bar/appbar.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/features/App/screens/Schedule/views/completed_schedule.dart';
import 'package:graduateproject/features/App/screens/Schedule/views/upcoming_schedule.dart';


import '../../../../../../utils/helpers/helper_functions.dart';
import 'views/canceled_schedule.dart';
import 'views/widgets/Inkwell_schedules_screens.dart';

class ScheduleScreens extends StatefulWidget {
  const ScheduleScreens({super.key});

  @override
  State<ScheduleScreens> createState() => _ScheduleScreensState();
}

class _ScheduleScreensState extends State<ScheduleScreens> {
  int buttonIndex = 0;
  final schedule = [
     Upcomingschedule(),
    const Completedschedule(),
    const Canceledschedule(),
  ];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: true,
        leadingOnPress: () => Get.back(),
        title: Text(
          "My Appointments",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(TSizes.defaultSpace),
          child: Column(
            children: [
              Container(
                width: THelperFunctions.screenWidth(),
                decoration: BoxDecoration(
                  color: dark ? MColors.grey : const Color(0xffD3E6FF),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CustomInkwellScheduleScreens(
                      onpress: () {
                        setState(() {
                          buttonIndex = 0;
                        });
                      },
                      title: "Upcoming",
                      backGroundColor: buttonIndex == 0
                          ? MColors.primary
                          : Colors.transparent,
                      textColor:
                          buttonIndex == 0 ? MColors.white : MColors.black,
                    ),
                    CustomInkwellScheduleScreens(
                      onpress: () {
                        setState(() {
                          buttonIndex = 1;
                        });
                      },
                      title: "Completed",
                      backGroundColor: buttonIndex == 1
                          ? MColors.primary
                          : Colors.transparent,
                      textColor:
                          buttonIndex == 1 ? MColors.white : MColors.black,
                    ),
                    CustomInkwellScheduleScreens(
                      onpress: () {
                        setState(() {
                          buttonIndex = 2;
                        });
                      },
                      title: "Canceld",
                      backGroundColor: buttonIndex == 2
                          ? MColors.primary
                          : Colors.transparent,
                      textColor:
                          buttonIndex == 2 ? MColors.white : MColors.black,
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: TSizes.spaceBtwSections,
              ),
              schedule[buttonIndex],
            ],
          ),
        ),
      ),
    );
  }
}
