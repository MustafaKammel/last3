import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/widgets/app_bar/appbar.dart';
import '../../../../common/widgets/common_images/circular_image.dart';
import '../../../../common/widgets/texts/section_heading.dart';
import '../../../../utils/constants/image_string.dart';
import '../../../../utils/constants/sizes.dart';
import 'widgets/profile_menu.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({Key? key});

  User? user = FirebaseAuth.instance.currentUser;
  final  role = GetStorage().read('role');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: true,
        title: Text(
          "My Profile",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder<DocumentSnapshot>(
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
          return SingleChildScrollView(
            padding: const EdgeInsets.all(TSizes.defaultSpace),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          _showFullScreenImage(context, userData[role == 'doctor' ?'docimage' : 'image']);
                        },
                        child: CircleAvatar(
                          backgroundImage: userData['image'] != ''
                              ? NetworkImage(userData['image'])
                              : AssetImage('assets/images/profile.png')
                          as ImageProvider,
                          radius: 80,
                        ),
                      ),
                      TextButton(
                        onPressed: () => _pickAndUploadImage(context),
                        child: const Text("Change profile picture"),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwItems / 2),
                const Divider(),
                const SizedBox(height: TSizes.spaceBtwItems),
                const SectionHeading(
                  title: "Profile Information",
                  showActionButton: false,
                ),
                ProfileMenu(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildEditDialog(
                        context,
                        'name',
                        userData['name'],
                      ),
                    );
                  },
                  title: "Name",
                  value: userData['name'] ?? "",
                ),
                ProfileMenu(
                  onTap: () {
                    // اضافة التعليقات اللازمة هنا لتعديل البيانات
                    // showDialog(
                    //   context: context,
                    //   builder: (context) => _buildEditDialog(
                    //     context,
                    //     'email', // اسم الحقل الذي تريد تعديله
                    //     userData['email'], // القيمة الحالية للحقل
                    //   ),
                    // );
                  },
                  title: "Email",
                  value: userData['email'] ?? "",
                ),
                ProfileMenu(
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) => _buildEditDialog(
                        context,
                        'about',
                        userData['about'],
                      ),
                    );
                  },
                  title: "About",
                  value: userData['about'] ?? "",
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Future<void> _pickAndUploadImage(BuildContext context) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      final file = File(pickedFile.path);

      try {
        final storageRef = FirebaseStorage.instance
            .ref()
            .child('profile_images')
            .child('${user!.uid}.jpg');

        await storageRef.putFile(file);
        final downloadUrl = await storageRef.getDownloadURL();

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user!.uid)
            .update({'image': downloadUrl});

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Profile picture updated successfully')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image: $e')),
        );
      }
    }
  }

  Widget _buildEditDialog(
      BuildContext context, String field, String initialValue) {
    String updatedValue = initialValue;

    return AlertDialog(
      title: Text('Edit $field'),
      content: TextFormField(
        initialValue: initialValue,
        onChanged: (newValue) => updatedValue = newValue,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            FirebaseFirestore.instance
                .collection('users')
                .doc(FirebaseAuth.instance.currentUser!.uid)
                .update({field: updatedValue});
            Navigator.pop(context);
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _showFullScreenImage(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Image.network(
                imageUrl,
                fit: BoxFit.contain,
              ),
            ),
          ),
        );
      },
    );
  }
}
