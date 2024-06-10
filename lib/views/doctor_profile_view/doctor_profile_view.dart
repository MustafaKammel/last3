import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:graduateproject/views/book_appointment_view/book_appointment_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/widgets/app_bar/appbar.dart';
import '../../features/App/screens/chat/Layout.dart';
import '../../features/App/screens/chat/firebase/fire_database.dart';
import '../../features/App/screens/chat/screens/Home/chat_home.dart';
import '../../utils/constants/text_strings.dart';

class DoctorProfileView extends StatefulWidget {
  final DocumentSnapshot doc;

  const DoctorProfileView({super.key, required this.doc});

  @override
  State<DoctorProfileView> createState() => _DoctorProfileViewState();
}

class _DoctorProfileViewState extends State<DoctorProfileView> {
  final role = GetStorage().read('role');
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      backgroundColor: dark ? MColors.darkerGrey : MColors.grey,
      appBar: AppBarWidget(
        showBackArrow: true,
        leadingOnPress: () => Get.back(),
        title: Text(
          "Doctor Details",
          style: dark
              ? Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: MColors.white)
              : Theme.of(context)
                  .textTheme
                  .headlineMedium!
                  .apply(color: MColors.black),
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .doc(widget.doc['docId']) // Ensuring the correct docId is used
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            }
            if (!snapshot.hasData || snapshot.data == null) {
              return Center(child: Text('No data available'));
            }
            var docData = snapshot.data!;
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircleAvatar(
                          backgroundImage: docData['docimage'] != ''
                              ? NetworkImage(docData['docimage'])
                              : AssetImage('assets/images/doctors/doctor_1.jpg')
                                  as ImageProvider,
                          radius: 80,
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Dr.${docData['docName']}',
                          style: TextStyle(
                            color: dark ? MColors.white : MColors.black,
                            fontSize: 23,
                            fontWeight: FontWeight.w600, // Slightly bolder font
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          docData['docCategory'],
                          style: TextStyle(
                            color: dark ? Colors.grey[400] : MColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            _contactIcon(
                              context,
                              icon: Icons.call,
                              onPressed: () async {
                                final url = 'tel:${docData['docPhone']}';
                                if (await canLaunch(url)) {
                                  await launch(url);
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "Could not launch $url",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                              },
                              darkMode: dark,
                            ),
                            const SizedBox(width: 20),
                            _contactIcon(
                              context,
                              icon: CupertinoIcons.chat_bubble_text_fill,
                              onPressed: () async {
                                if (docData['docEmail'] != null) {
                                  FireData()
                                      .createRoom(docData['docEmail'])
                                      .then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LayoutApp(),
                                      ),
                                    );
                                  });
                                } else {
                                  Fluttertoast.showToast(
                                    msg: "This doctor is unavailable.",
                                    toastLength: Toast.LENGTH_SHORT,
                                    gravity: ToastGravity.BOTTOM,
                                  );
                                }
                              },
                              darkMode: dark,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    width: double.infinity,
                    padding:
                        const EdgeInsets.only(left: 15, top: 20, right: 15),
                    decoration: BoxDecoration(
                      color: dark ? MColors.darkerGrey : MColors.white,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: dark ? Colors.black12 : Colors.grey[400]!,
                          blurRadius: 10,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "About Doctor",
                          style: TextStyle(
                            color: MColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          docData['docAbout'],
                          style: TextStyle(
                            fontSize: 16,
                            color: dark ? Colors.grey[400] : Colors.black54,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _infoTile(
                          title: "Phone Number",
                          content: docData['docPhone'],
                          icon: Icons.phone,
                          darkMode: dark,
                        ),
                        const SizedBox(height: 20),
                        _infoTile(
                          title: "Email",
                          content: docData['docEmail'],
                          icon: Icons.email,
                          darkMode: dark,
                        ),
                        const SizedBox(height: 20),
                        _infoTile(
                          title: "Duration from",
                          content: docData['docTimingfrom'],
                          icon: Icons.access_time,
                          darkMode: dark,
                        ),
                        _infoTile(
                          title: "Duration to",
                          content: docData['docTimingto'],
                          icon: Icons.access_time,
                          darkMode: dark,
                        ),
                        const SizedBox(height: 20),
                        _infoTile(
                          title: "Services",
                          content: docData['docService'],
                          icon: Icons.local_hospital,
                          darkMode: dark,
                        ),
                        const SizedBox(height: 20),
                        const Text(
                          "Location",
                          style: TextStyle(
                            color: MColors.primary,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: dark ? MColors.dark : Color(0xFFF0EEFA),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.location_on,
                              color: MColors.primary,
                              size: 30,
                            ),
                          ),
                          title: Text(
                            docData['docAddress'],
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: dark ? Colors.grey[400] : MColors.black,
                            ),
                          ),
                          subtitle: Text(
                            "address line of the medical center",
                            style: TextStyle(
                              color: dark ? Colors.grey[600] : Colors.black54,
                            ),
                          ),
                          onTap: () async {
                            final address = docData['docAddress'];
                            final url =
                                'https://www.google.com/maps/search/?api=1&query=${Uri.encodeComponent(address)}';
                            if (await canLaunch(url)) {
                              await launch(url);
                            } else {
                              Fluttertoast.showToast(
                                msg: "Could not launch Maps",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(15),
        height: 130,
        decoration:  BoxDecoration(color: dark ? Colors.black :MColors.white , boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
        ]),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                 Text(
                  "Consultation price",
                  style: TextStyle(
                    color: dark ?Colors.white:Colors.black54,
                  ),
                ),
                Text(
                  "${widget.doc['docSalary']} LE",
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () async {
                  Get.to(() => BookAppointmentView(
                        docId: widget.doc['docId'],
                        docName: widget.doc['docName'],
                        amount: double.parse(
                          widget.doc['docSalary'].toString(),
                        ),
                        Services: widget.doc['docService'],
                      ));
                },
                child:  Text(
                  TTexts.bookAppointment,
                  style: TextStyle(color: dark ?Colors.white:Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _contactIcon(BuildContext context,
      {required IconData icon,
      required VoidCallback onPressed,
      required bool darkMode}) {
    return Container(
      decoration: BoxDecoration(
        color: darkMode ? MColors.dark : MColors.light,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: darkMode ? Colors.black26 : Colors.grey[300]!,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(
          icon,
          color: darkMode ? MColors.white : MColors.black,
          size: 25,
        ),
        onPressed: onPressed,
      ),
    );
  }

  Widget _infoTile({
    required String title,
    required String content,
    required IconData icon,
    required bool darkMode,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: darkMode ? MColors.primary : MColors.dark,
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                color: darkMode ? Colors.grey[400] : MColors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 5),
            Text(
              content,
              style: TextStyle(
                fontSize: 14,
                color: darkMode ? Colors.grey[500] : Colors.black54,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
