import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:graduateproject/features/authentication/controllers/auth_controller.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';

import '../../../../../../../utils/constants/sizes.dart';
import '../../../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../../../views/doctor/location_picker_screen.dart';
import 'terms_and_conditions_checkbox.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({Key? key}) : super(key: key);

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final _formKey = GlobalKey<FormState>();
  var isDoctor = false;
  bool passwordVisible = false;
  String _selectedDate = DateFormat("yyyy-MM-dd").format(DateTime.now());

  String _startDate = DateFormat('HH:mm:ss').format(DateTime.now());

  String _endDate =
      DateFormat('HH:mm:ss').format(DateTime.now().add(Duration(minutes: 15)));

  var controller = Get.put(AuthController());

  // LatLng? _selectedLocation;
  List<String> categoryList = [
    "Cardiolo", //أمراض القلب
    "Ophthalmology", //طب العيون
    "pulmonology", //أمراض الرئة
    "Dentist", //طبيب أسنان
    "Neurology", //علم الأعصاب
    "Orthopedic", //تقويم العظام
    "Nephrology", //أمراض الكلى
    "Otolaryngolgy",
    // Add more categories as needed
  ];
  List<String> _selectedDays = [];
  final List<String> availableDays = [
    'Saturday',
    'Sunday',
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday'
  ];

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.name,
            controller: controller.fullnameController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.user_edit),
              labelText: TTexts.username,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Username is required!';
              }
              return null;
            },
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: controller.emailController,
            decoration: const InputDecoration(
              prefixIcon: Icon(Iconsax.direct),
              labelText: TTexts.email,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email is required.';
              }

              final emailRegExp = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');

              if (!emailRegExp.hasMatch(value)) {
                return 'Invalid email address.';
              }

              return null;
            },
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),

          TextFormField(
            keyboardType: TextInputType.visiblePassword,
            controller: controller.passwordController,
            obscureText: !passwordVisible,
            decoration: InputDecoration(
              prefixIcon: const Icon(Iconsax.password_check),
              labelText: TTexts.password,
              suffixIcon: IconButton(
                icon: Icon(passwordVisible ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Password is required.';
              }

              if (value.length < 6) {
                return 'Password must be at least 6 characters long.';
              }

              if (!value.contains(RegExp(r'[A-Z]'))) {
                return 'Password must contain at least one uppercase letter.';
              }

              if (!value.contains(RegExp(r'[0-9]'))) {
                return 'Password must contain at least one number.';
              }

              if (!value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
                return 'Password must contain at least one special character.';
              }

              return null;
            },
          ),

          const SizedBox(height: TSizes.spaceBtwInputFields),
          SwitchListTile(
            title: const Text("Sign up as a Doctor"),
            value: isDoctor,
            onChanged: (newValue) {
              setState(() {
                isDoctor = newValue;
              });
            },
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Visibility(
            visible: isDoctor,
            child: Column(
              children: [
                TextFormField(
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  // keyboardType: TextInputType.text,
                  controller: controller.aboutController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.info_circle),
                    labelText: "About",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'About is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Iconsax.category),
                    ),
                    icon: const Icon(Icons.arrow_drop_down),
                    value: controller.categoryslected,
                    alignment: AlignmentDirectional.centerEnd,
                    isExpanded: true,
                    isDense: true,
                    style: TextStyle(
                      color: dark ? Colors.white : Colors.black,
                    ),
                    items: categoryList.map((category) {
                      return DropdownMenuItem<String>(
                        child: Text(category),
                        value: category,
                      );
                    }).toList(),
                    onChanged: (String? newvalue) {
                      setState(() {
                        controller.categoryslected = newvalue!;
                      });
                    },
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  keyboardType: TextInputType.text,
                  controller: controller.servicesController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.medical_services),
                    labelText: "Services",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Services are required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  keyboardType: TextInputType.streetAddress,
                  controller: controller.addressController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.location_on),
                    labelText: "Address",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Address is required.';
                    }
                    return null;
                  },
                ),
                // GestureDetector(
                //   onTap: () async {
                //     LatLng? location = await Navigator.push(
                //       context,
                //       MaterialPageRoute(
                //         builder: (context) => LocationPickerScreen(),
                //       ),
                //     );
                //
                //     if (location != null) {
                //       setState(() {
                //         _selectedLocation = location;
                //       });
                //       controller.addressController.text =
                //           'Lat: ${location.latitude}, Lng: ${location.longitude}';
                //     }
                //   },
                //   child: AbsorbPointer(
                //     child: TextFormField(
                //       controller: controller.addressController,
                //       decoration: const InputDecoration(
                //         prefixIcon: Icon(Icons.location_on),
                //         labelText: "Location",
                //         hintText: "Tap to select location",
                //       ),
                //       validator: (value) {
                //         if (value == null || value.isEmpty) {
                //           return 'Location is required.';
                //         }
                //         return null;
                //       },
                //     ),
                //   ),
                // ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  keyboardType: TextInputType.phone,
                  controller: controller.phoneController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.call),
                    labelText: "Phone Number",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Phone number is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _selectStartTime(context);
                        },
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          enabled: false,
                          controller: controller.timingControllerfrom,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.timelapse_outlined),
                            labelText: "Duration From",
                            hintText: _startDate.toString(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          _selectEndTime(context);
                        },
                        child: TextFormField(
                          keyboardType: TextInputType.datetime,
                          enabled: false,
                          controller: controller.timingControllerto,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.timelapse_outlined),
                            labelText: "Duration To",
                            hintText: _endDate.toString(),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: Colors.grey[400]!,
                      width: 1,
                    ),
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Select Unavailable Days",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Wrap(
                        spacing: 17,
                        children: availableDays.map((day) {
                          return FilterChip(
                            label: Text(day),
                            selected: _selectedDays.contains(day),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  _selectedDays.add(day);
                                } else {
                                  _selectedDays.remove(day);
                                }
                              });
                            },
                            selectedColor: Colors.red,
                            backgroundColor:
                                dark ? MColors.dark : MColors.light,
                            checkmarkColor:
                                dark ? MColors.white : MColors.black,
                            showCheckmark: true,
                            elevation: 2,
                            pressElevation: 5,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 9),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
                TextFormField(
                  keyboardType: TextInputType.number,
                  controller: controller.salaryController,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.attach_money_rounded),
                    labelText: "Add Your Price",
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Price is required.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: TSizes.spaceBtwInputFields),
              ],
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),

          // Terms & Conditions of CheckBox
          const TermsAndConditionsCheckBox(),

          const SizedBox(height: TSizes.spaceBtwSections),

          // Create Account Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                try {
                  if (_formKey.currentState!.validate()) {
                    // Perform form validation
                    if (isDoctor) {
                      if (_selectedDays.isEmpty) {
                        throw Exception(
                            "Please select at least one unavailable day");
                      } else if (!validateDurationDifference(
                          _startDate, _endDate)) {
                        throw Exception(
                            "End time must be at least 15 minutes after start time");
                        // } else if (_selectedLocation == null) {
                        //   throw Exception("Please select a location on the map.");
                      } else {
                        controller.signupUser(isDoctor, _selectedDays);
                      }
                    } else {
                      controller.signupUser(isDoctor, _selectedDays);
                    }
                  }
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(e.toString()),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: const Text(TTexts.createAccount),
            ),
          ),
          const SizedBox(height: TSizes.spaceBtwInputFields),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Do you have an account?"),
              GestureDetector(
                onTap: () {
                  Get.back();
                },
                child: Text(
                  " Log in",
                  style: TextStyle(fontSize: 15, color: Colors.blue),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      currentDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2025),
    );
    setState(() {
      if (selected != null) {
        _selectedDate = DateFormat('yyyy-MM-dd').format(selected).toString();
      } else {
        _selectedDate =
            DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
      }
    });
  }

  _selectStartTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    var date = join(DateTime.parse(_selectedDate), selected!);
    var formattedTime = DateFormat("HH:mm:ss").format(date);

    setState(() {
      _startDate = formattedTime;
      controller.timingControllerfrom.text = formattedTime;
    });
  }

  DateTime join(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  _selectEndTime(BuildContext context) async {
    final TimeOfDay? selected = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    var date = join(DateTime.parse(_selectedDate), selected!);
    var formattedTime = DateFormat("HH:mm:ss").format(date);

    setState(() {
      _endDate = formattedTime;
      controller.timingControllerto.text = formattedTime;
    });
  }

  bool validateDurationDifference(String? fromTime, String? toTime) {
    if (fromTime == null || toTime == null) {
      return false;
    }

    var fromDateTime = DateFormat('HH:mm:ss').parse(fromTime);
    var toDateTime = DateFormat('HH:mm:ss').parse(toTime);

    var differenceInMinutes = toDateTime.difference(fromDateTime).inMinutes;

    return !toDateTime.isBefore(fromDateTime.add(Duration(minutes: 15))) &&
        differenceInMinutes >= 0;
  }
}
