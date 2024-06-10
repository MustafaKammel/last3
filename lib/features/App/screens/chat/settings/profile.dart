import 'dart:io';

import 'package:flutter/material.dart';
import 'package:full_screen_image/full_screen_image.dart';
import 'package:get_storage/get_storage.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../firebase/fire_database.dart';
import '../firebase/fire_storage.dart';
import '../models/user_model.dart';
import '../provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  TextEditingController namecon = TextEditingController();
  static TextEditingController aboutcon = TextEditingController();
  ChatUser? me;
  String _img = "";
  bool nameEdit = false;
  bool aboutEdit = false;
  final role = GetStorage().read('role');

  @override
  void initState() {
    me = Provider.of<providerApp>(context, listen: false).me;
    super.initState();
    namecon.text = me!.name!;
    aboutcon.text = me!.about!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Center(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    _img == ""
                        ? me!.image == ""
                            ? FullScreenWidget(
                                disposeLevel: DisposeLevel.High,
                                child: const CircleAvatar(
                                  radius: 70,
                                ))
                            : FullScreenWidget(
                                disposeLevel: DisposeLevel.High,
                                child: CircleAvatar(
                                  radius: 70,
                                  backgroundImage: NetworkImage(me!.image!),
                                ))
                        : FullScreenWidget(
                            disposeLevel: DisposeLevel.High,
                            child: CircleAvatar(
                              radius: 70,
                              backgroundImage: FileImage(File(_img)),
                            )),
                    Positioned(
                      bottom: -5,
                      right: -5,
                      child: IconButton.filled(
                        onPressed: () async {
                          ImagePicker imagepicker = ImagePicker();
                          XFile? image = await imagepicker.pickImage(
                              source: ImageSource.gallery);
                          if (image != null) {
                            setState(() {
                              _img = image.path;
                            });
                            FireStorage()
                                .updateProfileImage(file: File(image.path));
                          }
                        },
                        icon: const Icon(Iconsax.edit),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        nameEdit = true;
                      });
                    },
                    icon: const Icon(Iconsax.edit),
                  ),
                  leading: const Icon(Iconsax.user_octagon),
                  title: TextField(
                    controller: namecon,
                    enabled: nameEdit,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'Name',
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  trailing: IconButton(
                    onPressed: () {
                      setState(() {
                        aboutEdit = true;
                      });
                    },
                    icon: const Icon(Iconsax.edit),
                  ),
                  leading: const Icon(Iconsax.information),
                  title: TextField(
                    controller: aboutcon,
                    enabled: aboutEdit,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      labelText: 'About',
                    ),
                  ),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.direct),
                  title: const Text('Email'),
                  subtitle: Text(me!.email.toString()),
                ),
              ),
              Card(
                child: ListTile(
                  leading: const Icon(Iconsax.direct),
                  title: const Text('Joind on'),
                  subtitle: Text(me!.createdAt.toString()),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (namecon.text.isNotEmpty && aboutcon.text.isNotEmpty) {
                    FireData()
                        .editProfile(namecon.text, aboutcon.text)
                        .then((value) {
                      setState(() {
                        nameEdit = false;
                        aboutEdit = false;
                      });
                    });
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Theme.of(context).colorScheme.primaryContainer,
                  padding: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Center(
                    child: Text(
                  "Save",
                  // style: TextStyle(color: Colors.black87),
                )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
