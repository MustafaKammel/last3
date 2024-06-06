import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/Notifications/notifications_services.dart';
import 'package:graduateproject/utils/consts/consts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import '../../../../../common/widgets/app_bar/appbar.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../views/appointment_details_view/appointment_details_view.dart';
import '../../../../authentication/controllers/auth_controller.dart';
import '../../../controllers/appointment_controller.dart';

class Upcomingschedule extends StatelessWidget {
  final bool isDoctor;

  Upcomingschedule({super.key, this.isDoctor = false});

  var user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(AppointmnetController());
    final dark = THelperFunctions.isDarkMode(context);
    Size size = MediaQuery.of(context).size;
    String name = user!.displayName ?? "";
    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: true,
        title: Text(
          "My Appoinments",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection('appointments')
              .where('userId',
                  isEqualTo: FirebaseAuth.instance.currentUser!.uid)
              .snapshots(),
          builder:
              (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
            DateTime end, start;
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              var data = snapshot.data?.docs;
              if (data!.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Lottie.asset('assets/Animations/Sad2.json'),
                      SizedBox(height: 20),
                      Text(
                        'No appointments found!',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                );
              }
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView.builder(
                  itemCount: data?.length ?? 0,
                  itemBuilder: (BuildContext context, int index) {
                    end = DateTime.parse(
                        snapshot.data!.docs[index]['bookingEnd'].toString());
                    start = DateTime.parse(
                        snapshot.data!.docs[index]['bookingStart'].toString());
                    var timestart = DateFormat('hh:mm a').format(start);
                    var timeend = DateFormat('hh:mm a').format(end);
                    var datestart = DateFormat('dd-MM-yyyy').format(start);
                    var dateend = DateFormat('dd-MM-yyyy').format(end);
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: dark ? MColors.darkContainer : MColors.white,
                            borderRadius: BorderRadius.circular(10),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ]),
                        child: SizedBox(
                          width: size.width,
                          child: Column(
                            children: [
                              ListTile(
                                onTap: () => Get.to(
                                  () => AppointmentDetailsView(
                                    doc: data[index],
                                  ),
                                ),
                                title: Text(
                                  'Dr.${data![index]['userName']}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge!
                                      .apply(
                                        color: dark
                                            ? MColors.white
                                            : MColors.black,
                                      ),
                                ),
                                subtitle: Text(
                                  "${data[index]['serviceName']}",
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall!
                                      .apply(
                                        color: dark
                                            ? MColors.white
                                            : MColors.black,
                                      ),
                                ),
                                trailing: IconButton(
                                  onPressed: () {
                                    showDialog(
                                      context: context,
                                      builder: (BuildContext context) {
                                        TextEditingController reasonController =
                                            TextEditingController();
                                        return AlertDialog(
                                          title: Text("Confirm Deletion"),
                                          content: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Text(
                                                  "Are you sure you want to delete this appointment?"),
                                              SizedBox(
                                                height: 20,
                                              ),
                                              TextField(
                                                controller: reasonController,
                                                decoration: InputDecoration(
                                                  hintText:
                                                      "Enter reason for cancellation",
                                                ),
                                              ),
                                            ],
                                          ),
                                          actions: <Widget>[
                                            TextButton(
                                              child: Text("Cancel"),
                                              onPressed: () {
                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            TextButton(
                                              child: Text("Delete"),
                                              onPressed: () {
                                                // Delete the appointment

                                                FirebaseFirestore.instance
                                                    .collection('appointments')
                                                    .doc(data[index].id)
                                                    .delete()
                                                    .then((value) =>
                                                        FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'notifications')
                                                            .add({
                                                          'uid': data[index]
                                                              ['serviceId'],
                                                          'title':
                                                              'HealHive',
                                                          'body':
                                                              'Your Appointment Canceled by \n$name:${data![index]['userEmail']}.\nReason: ${reasonController.text}',
                                                          'Date': DateTime.now()
                                                              .toString(),
                                                          'isShow': false,
                                                        }));
                                                Navigator.of(context)
                                                    .pop(); // Close the dialog
                                              },
                                            ),
                                          ],
                                        );
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Iconsax.calendar_remove,
                                    color: Colors.red,
                                  ),
                                ),
                                leading: const CircleAvatar(
                                  radius: 25,
                                  backgroundImage: AssetImage(
                                      "assets/images/doctoricon.png"),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 15),
                                child: Divider(
                                  thickness: 1,
                                  height: 20,
                                ),
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Iconsax.calendar_tick,
                                        color: dark
                                            ? MColors.white
                                            : MColors.black,
                                      ),
                                      const SizedBox(
                                        width: TSizes.xs,
                                      ),
                                      Text(
                                        datestart,
                                        style: TextStyle(
                                          color: dark
                                              ? MColors.white
                                              : MColors.black,
                                        ),
                                      )
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(
                                            Icons.access_alarm,
                                            color: dark
                                                ? MColors.white
                                                : MColors.black,
                                          ),
                                          const SizedBox(
                                            width: TSizes.xs,
                                          ),
                                          Text(
                                            timestart,
                                            style: TextStyle(
                                              color: dark
                                                  ? MColors.white
                                                  : MColors.black,
                                            ),
                                          )
                                        ],
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.all(5),
                                        decoration: const BoxDecoration(
                                            color: Colors.green,
                                            shape: BoxShape.circle),
                                      ),
                                      const SizedBox(
                                        width: TSizes.xs,
                                      ),
                                      Text(
                                        "Confirmed",
                                        style: TextStyle(
                                          color: dark
                                              ? MColors.white
                                              : MColors.black,
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: TSizes.md,
                              ),
                              const SizedBox(
                                height: TSizes.md,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
            }
          }),
    );
  }
}
