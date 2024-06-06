import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../../../common/widgets/Doctors/doctor_card_vertical.dart';
import '../../../../views/doctor_profile_view/doctor_profile_view.dart';
import '../../../authentication/controllers/home_controller.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(HomeController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "  My Favorite Doctors",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<List<String>>(
        stream: controller.getFavoriteDoctors(),
        builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (snapshot.data!.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/Animations/Sad.json'),
                  SizedBox(height: 20),
                  Text(
                    'No favorite doctors found!',
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            var favoriteDoctorIds = snapshot.data!;
            return FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('doctors')
                  .where(FieldPath.documentId, whereIn: favoriteDoctorIds)
                  .get(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Lottie.asset('assets/Animations/Sad.json'),
                        SizedBox(height: 20),
                        Text(
                          'No favorite doctors found!',
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                  );
                }
                var data = snapshot.data?.docs ?? [];
                return Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: GridView.builder(
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisExtent: 220,
                      mainAxisSpacing: 8,
                      crossAxisSpacing: 8,
                    ),
                    itemCount: data.length,
                    itemBuilder: (BuildContext context, int index) {
                      var doc = data[index];
                      return DoctorCardVertical(
                        image: 'assets/images/doctors/doctor_1.jpg',
                        subtitle: doc['docCategory'],
                        title: doc['docName'],
                        onTap: () {
                          Get.to(() => DoctorProfileView(
                            doc: doc,
                          ));
                        },
                        isFavorite: true,
                        docId: doc.id,
                      );
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
