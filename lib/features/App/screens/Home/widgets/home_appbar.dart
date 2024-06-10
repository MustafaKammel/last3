import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/Notifications/notification_screen.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../../common/widgets/app_bar/appbar.dart';
import '../../../../../../../common/widgets/appointments/appointment_counter_icon.dart';
import '../../../../../../../utils/constants/colors.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../personalization/controllers/setting_controller.dart';

class HomeAppBar extends StatelessWidget {
   HomeAppBar({super.key});
  User? user = FirebaseAuth.instance.currentUser;
  @override
  Widget build(BuildContext context) {
    var controller = Get.put(SettingController());
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(user!.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        if (!snapshot.hasData || snapshot.data == null) {
          return Text('No data available');
        }

        final userData = snapshot.data!;
        return AppBarWidget(
          title: Row(
            children: [
              CircleAvatar(
                backgroundImage: userData['image'] != ''
                    ? NetworkImage(userData['image'])
                    : AssetImage('assets/images/profile.png')
                as ImageProvider,
              ),
              // IconButton(
              //   onPressed: () {},
              //   icon: const Icon(
              //     Iconsax.menu,
              //     color: MColors.white,
              //   ),
              // ),
              const SizedBox(width: 20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    TTexts.homeAppBarTitle,
                    style: Theme.of(context)
                        .textTheme
                        .labelMedium!
                        .apply(color: MColors.grey),
                  ),
                  Text(
                    userData['name'],
                    style: Theme.of(context)
                        .textTheme
                        .headlineSmall!
                        .apply(color: MColors.white),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            AppointmentCounterIcon(
              onpressed: () {
                    Navigator.push(context,MaterialPageRoute(builder: (_)=>NotificationScreen()));
              },
              iconColor: MColors.white,
            ),
          ],
        );
      }
    );
  }
}
