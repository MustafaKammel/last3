import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:graduateproject/views/doctor_profile_view/doctor_profile_view.dart';

import '../../../../../common/widgets/Doctors/doctor_card_vertical.dart';
import '../../../../../common/widgets/app_bar/appbar.dart';
import '../../../../../utils/consts/consts.dart';

class CategoryDetailsView extends StatefulWidget {
  final String catName;
  const CategoryDetailsView({super.key, required this.catName});

  @override
  State<CategoryDetailsView> createState() => _CategoryDetailsViewState();
}

class _CategoryDetailsViewState extends State<CategoryDetailsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: true,
        leadingOnPress: () => Get.back(),
        title: Text(
          widget.catName,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title:
      //       AppStyle.bold(size: 18, title: catName, color: AppColor.whiteColor),
      // ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('doctors')
            .where('docCategory', isEqualTo: widget.catName)
            .get(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
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
                itemCount: data?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  var doc = data[index];
                  return DoctorCardVertical(
                    image: doc['docimage'] != ''
                        ? NetworkImage(doc['docimage'])
                        : AssetImage('assets/images/doctors/doctor_1.jpg')
                    as ImageProvider,
                    subtitle: data![index]['docCategory'],
                    title: 'Dr.${data[index]['docName']}',
                    onTap: () {
                      Get.to(() => DoctorProfileView(
                            doc: data[index],
                          ));
                    },
                      isFavorite: data[index]['isFavorite'] ?? false, docId: data![index]['docId'],
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
