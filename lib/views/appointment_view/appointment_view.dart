import 'package:graduateproject/features/App/screens/Schedule/views/canceled_schedule.dart';
import 'package:graduateproject/features/authentication/controllers/auth_controller.dart';
import '../../common/widgets/app_bar/appbar.dart';
import '../../features/App/screens/Schedule/views/completed_schedule.dart';
import '../../features/App/screens/Schedule/views/upcoming_schedule.dart';
import '../../features/App/screens/Schedule/views/widgets/Inkwell_schedules_screens.dart';
import '../../utils/constants/colors.dart';
import '../../utils/constants/sizes.dart';
import '../../utils/consts/consts.dart';
import '../../utils/helpers/helper_functions.dart';

class AppointmentView extends StatefulWidget {
  final bool isDoctor;
  const AppointmentView({super.key, this.isDoctor = false});

  @override
  State<AppointmentView> createState() => _AppointmentViewState();
}

class _AppointmentViewState extends State<AppointmentView> {
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
          showBackArrow: false,
          //leadingOnPress: () => Get.back(),
          title: Text(
            "Appoinments",
            style: Theme.of(context).textTheme.headlineMedium,
          ),
          actions: [
            IconButton(
                onPressed: () {
                  AuthController().signout();
                },
                icon: const Icon(Icons.power_settings_new_rounded))
          ],
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
        ));
  }
}
