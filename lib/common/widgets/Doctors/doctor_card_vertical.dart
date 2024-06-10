import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:iconsax/iconsax.dart';
import '../../../features/authentication/controllers/home_controller.dart';
import '../../../utils/constants/colors.dart';
import '../../../utils/constants/sizes.dart';
import '../../../utils/helpers/helper_functions.dart';
import '../../styles/shadow_style.dart';
import '../common_images/rounded_image.dart';
import '../custom_shapes/contianers/rounded_container.dart';
import '../texts/doctor_title_text.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DoctorCardVertical extends StatefulWidget {
  DoctorCardVertical({
    Key? key,
    required this.docId,
    required this.title,
    required this.subtitle,
    required this.image,
    required this.isFavorite,
    this.onTap,
  }) : super(key: key);

  final String docId;
  var title, subtitle, image;
  final bool isFavorite;
  final void Function()? onTap;

  @override
  _DoctorCardVerticalState createState() => _DoctorCardVerticalState();
}

class _DoctorCardVerticalState extends State<DoctorCardVertical> {
  late bool _isFavorite;
  final controller = Get.put(HomeController());
  final String userId = FirebaseAuth.instance.currentUser!.uid;

  @override
  void initState() {
    super.initState();
    _isFavorite = widget.isFavorite;
    _loadFavoriteStatus();
  }

  Future<void> _loadFavoriteStatus() async {
    var userDoc = await FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .collection('favorites')
        .doc(widget.docId)
        .get();
    if (userDoc.exists) {
      setState(() {
        _isFavorite = userDoc.data()!['isFavorite'] ?? false;
      });
    }
  }

  void _toggleFavorite() async {
    await controller.toggleFavoriteStatus(widget.docId, _isFavorite);
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return GestureDetector(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(1),
        decoration: BoxDecoration(
          boxShadow: [ShadowStyle.verticalDoctorShadow],
          borderRadius: BorderRadius.circular(TSizes.productImageRadius),
          color: dark ? MColors.darkGrey : MColors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RoundedContainer(
              width: double.infinity,
              padding: const EdgeInsets.all(TSizes.sm),
              backGroundColor: dark ? MColors.dark : MColors.grey,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundImage: widget.image,
                    radius: 40,
                  ),
                  // RoundedImage(
                  //   imagUrl: widget.image,
                  //   applyImageRadius: true,
                  //   fit: BoxFit.fill,
                  //   height: 100,
                  //   width: double.infinity,
                  // ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: FavoriteButton(
                      iconSize: 40,
                      isFavorite: _isFavorite,
                      valueChanged: (_isFavorite) {
                        _toggleFavorite();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.sm),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  DoctorTitleText(
                    title: widget.title,
                    smallSize: true,
                  ),
                  Text(
                    widget.subtitle,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RoundedContainer(
                        radius: TSizes.sm,
                        width: 60,
                        backGroundColor: MColors.secondary.withOpacity(0.8),
                        padding: const EdgeInsets.symmetric(
                            horizontal: TSizes.sm, vertical: TSizes.xs),
                        child: const Row(
                          children: [
                            Icon(
                              Iconsax.star,
                              size: 12,
                            ),
                            SizedBox(
                              width: TSizes.xs,
                            ),
                            Text(
                              "9.5",
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: TSizes.iconLg * 1.2,
                        height: TSizes.iconLg * 1.2,
                        decoration: const BoxDecoration(
                          color: MColors.dark,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(TSizes.cardRadiusMd),
                            bottomRight:
                                Radius.circular(TSizes.productImageRadius),
                          ),
                        ),
                        child: IconButton(
                          icon: const Icon(
                            Iconsax.add,
                            color: MColors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
