// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/App/screens/Home/widgets/category_details_view.dart';
import 'package:iconsax/iconsax.dart';

import '../../../../../../../common/widgets/image_text/vertically_image_text.dart';

class HomeCategories extends StatelessWidget {
  HomeCategories({super.key});

  List icons = [
    "assets/icons/spicialists/heart.png",
    "assets/icons/spicialists/eye.png",
    "assets/icons/spicialists/lungs.png",
    "assets/icons/spicialists/tooth.png",
    "assets/icons/spicialists/brain.png",
    "assets/icons/spicialists/bones.png",
    "assets/icons/spicialists/kidney.png",
    "assets/icons/spicialists/ear.png",
    'assets/icons/hearing.png', // Use an icon for "All Specialties"
  ];

  List text = [
    "Cardiolo", //أمراض القلب
    "Ophthalmology", //طب العيون
    "pulmonology", //أمراض الرئة
    "Dentist", //طبيب أسنان
    "Neurology", //علم الأعصاب
    "Orthopedic", //تقويم العظام
    "Nephrology", //أمراض الكلى
    "Otolaryngolgy", //طب الأنف والأذن والحنجرة
    "All Specialties", //كل التخصصات
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: icons.length,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) {
          return VerticallyImageText(
            icon: icons[index],
            text: text[index],
            onTap: () {
              if (text[index] == "All Specialties") {
                Get.to(() => AllSpecialtiesView());
              } else {
                Get.to(() => CategoryDetailsView(catName: text[index]));
              }
            },
            image: icons[index],
          );
        },
      ),
    );
  }
}

class AllSpecialtiesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    List specialties = [
      {"name": "Cardiolo", "icon": "assets/icons/spicialists/heart.png"},
      {"name": "Ophthalmology", "icon": "assets/icons/spicialists/eye.png"},
      {"name": "pulmonology", "icon": "assets/icons/spicialists/lungs.png"},
      {"name": "Dentist", "icon": "assets/icons/spicialists/tooth.png"},
      {"name": "Neurology", "icon": "assets/icons/spicialists/brain.png"},
      {"name": "Orthopedic", "icon": "assets/icons/spicialists/bones.png"},
      {"name": "Nephrology", "icon": "assets/icons/spicialists/kidney.png"},
      {"name": "Otolaryngolgy", "icon": "assets/icons/spicialists/ear.png"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("All Specialties"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 1,
          ),
          itemCount: specialties.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Get.to(() => CategoryDetailsView(catName: specialties[index]["name"]));
              },
              child: Card(
                color: isDarkMode ? Colors.grey[800] : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      specialties[index]["icon"],
                      height: 80,
                      color: isDarkMode ? Colors.white : Colors.black,
                    ),
                    SizedBox(height: 10),
                    Text(
                      specialties[index]["name"],
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                    ),
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
