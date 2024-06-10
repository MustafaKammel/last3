import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:graduateproject/features/Notifications/notifications_services.dart';
import 'package:graduateproject/features/authentication/controllers/home_controller.dart';
import 'package:graduateproject/utils/constants/colors.dart';
import 'package:graduateproject/utils/constants/sizes.dart';
import 'package:graduateproject/utils/constants/text_strings.dart';
import 'package:graduateproject/utils/helpers/helper_functions.dart';
import 'package:graduateproject/views/doctor_profile_view/doctor_profile_view.dart';
import 'package:iconsax/iconsax.dart';
import 'package:lottie/lottie.dart';
import '../../../../../../common/widgets/custom_shapes/contianers/primary_header_container.dart';
import '../../../../../../common/widgets/texts/section_heading.dart';
import '../../../../../../common/widgets/Doctors/doctor_card_vertical.dart';
import 'widgets/home_appbar.dart';
import 'widgets/home_categories.dart';
import 'widgets/home_search.dart';
import 'widgets/promo_slider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isConnected = true; // Initially assume internet connection exists
  late HomeController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.put(HomeController());
    _checkInternetConnection();
    NotificationsServices().showBasicNotification();
  }

  Future<void> _checkInternetConnection() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    setState(() {
      _isConnected = connectivityResult != ConnectivityResult.none;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isConnected) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "No Internet Connection",
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  await _checkInternetConnection();
                },
                child: Text("Retry"),
              ),
            ],
          ),
        ),
      );
    }

    final dark = THelperFunctions.isDarkMode(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            PrimaryHeaderContainer(
              height: 380,
              child: Column(
                children: [
                  HomeAppBar(),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  const SearchHomePage(text: "Search"),
                  const SizedBox(
                    height: TSizes.spaceBtwSections,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: TSizes.defaultSpace),
                    child: Column(
                      children: [
                        const SectionHeading(
                          title: TTexts.homeSubTitle1,
                          showActionButton: false,
                          textColor: MColors.white,
                        ),
                        const SizedBox(
                          height: TSizes.spaceBtwItems,
                        ),
                        HomeCategories(),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(TSizes.defaultSpace),
              child: Column(
                children: [
                  const PromoSlider(),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  SectionHeading(
                    title: TTexts.homeSubTitle2,
                    showActionButton: false,
                    textColor: dark ? MColors.white : MColors.black,
                  ),
                  const SizedBox(
                    height: TSizes.spaceBtwItems,
                  ),
                  StreamBuilder<QuerySnapshot>(
                    stream: _controller.getDoctorListStream(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      } else if (!snapshot.hasData ||
                          snapshot.data!.docs.isEmpty) {
                        return Center(
                          child: Text('No Doctors Available !'),
                        );
                      } else {
                        var data = snapshot.data?.docs;
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: TSizes.gridViewSpacing,
                              crossAxisSpacing: TSizes.gridViewSpacing,
                              mainAxisExtent: 220,
                            ),
                            physics: const BouncingScrollPhysics(),
                            scrollDirection: Axis.vertical,
                            itemCount: data?.length ?? 0,
                            itemBuilder: (context, index) {
                              var doctorData = data![index];
                              return DoctorCardVertical(
                                docId: doctorData['docId'],
                                title: 'Dr.${doctorData['docName']}',
                                subtitle: doctorData['docCategory'],
                                image: doctorData['docimage'] != ''
                                    ? NetworkImage(doctorData['docimage'])
                                    : AssetImage('assets/images/doctors/doctor_1.jpg')
                                as ImageProvider,
                                isFavorite: doctorData['isFavorite'] ?? false,
                                onTap: () {
                                  Get.to(() => DoctorProfileView(
                                        doc: doctorData,
                                      ));
                                },
                              );
                            },
                          ),
                        );
                      }
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(() => ChatBotScreen());
        },
        child: Icon(Iconsax.message),
        backgroundColor: MColors.primary,
      ),
    );
  }
}

class ChatBotScreen extends StatefulWidget {
  @override
  State<ChatBotScreen> createState() => _ChatBotScreenState();
}

class _ChatBotScreenState extends State<ChatBotScreen> {
  final Map<String, String> faq = {
    "ما هو ضغط الدم الطبيعي؟": "ضغط الدم الطبيعي يكون حوالي 120/80 ملم زئبقي.",
    "ما هي أعراض السكري؟":
        "من أعراض السكري العطش الشديد، التبول المتكرر، والتعب الشديد.",
    "كيف يمكنني الوقاية من أمراض القلب؟":
        "يمكنك الوقاية من أمراض القلب باتباع نظام غذائي صحي، ممارسة الرياضة بانتظام، وتجنب التدخين.",
    "ما هي فوائد النوم الجيد؟":
        "يعزز النوم الجيد الصحة العقلية والجسدية، ويزيد من الطاقة والتركيز والإنتاجية.",
    "ما هي أعراض نقص فيتامين D؟":
        "من أعراض نقص فيتامين D الإرهاق، والضعف العام، وآلام العظام والعضلات.",
    "ما هي أسباب آلام الظهر؟":
        "من أسباب آلام الظهر الجلوس لفترات طويلة، والرفع الثقيل بطريقة خاطئة، ونقص التمارين الرياضية.",
    "كم عدد ساعات النوم الصحيح؟":
        "يُوصى بأن ينام البالغون ما بين 7 إلى 9 ساعات في الليلة الواحدة للحصول على نوم صحي.",
    "ما هي الأطعمة الغنية بالبروتين؟":
        "من الأطعمة الغنية بالبروتين اللحوم والأسماك والبيض والحليب ومشتقاته.",
    "ما هي أضرار التدخين على الصحة؟":
        "تشمل أضرار التدخين ارتفاع خطر الإصابة بأمراض القلب والسرطان وأمراض التنفس.",
    "كيف يمكن تقوية جهاز المناعة؟":
        "يمكن تقوية جهاز المناعة باتباع نمط حياة صحي، وتناول الغذاء المتوازن، وممارسة الرياضة بانتظام.",
    "ما هي أفضل طرق التخلص من الإجهاد؟":
        "من أفضل طرق التخلص من الإجهاد التمارين الرياضية، والتأمل، والاسترخاء، والنوم الجيد.",
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Q&A'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: Icon(Icons.close),
          ),
        ],
      ),
      body: Stack(
        children: [
          Lottie.asset(
            'assets/Animations/bg.json',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          ListView.builder(
            itemCount: faq.length,
            itemBuilder: (context, index) {
              final question = faq.keys.elementAt(index);
              final answer = faq.values.elementAt(index);
              return Card(
                elevation: 3,
                margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ExpansionTile(
                  title: Text(
                    question,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(answer),
                    ),
                  ],
                ),
              );
            },
          ),
          // Positioned(
          //   bottom: 20,
          //   right: 20,
          //   child: FloatingActionButton(
          //     onPressed: () {
          //       Navigator.of(context).push(
          //         MaterialPageRoute(builder: (context) => RockPaperScissorsGame()),
          //       );
          //     },
          //     child: Icon(Icons.gamepad),
          //   ),
          // ),
        ],
      ),
    );
  }
}

class RockPaperScissorsGame extends StatefulWidget {
  @override
  _RockPaperScissorsGameState createState() => _RockPaperScissorsGameState();
}

class _RockPaperScissorsGameState extends State<RockPaperScissorsGame> {
  var _result = '';

  void _play(String userChoice) {
    final random = Random().nextInt(3); // 0, 1, or 2
    final computerChoice = ['rock', 'paper', 'scissors'][random];

    if (userChoice == computerChoice) {
      setState(() {
        _result = 'It\'s a draw!';
      });
    } else if ((userChoice == 'rock' && computerChoice == 'scissors') ||
        (userChoice == 'paper' && computerChoice == 'rock') ||
        (userChoice == 'scissors' && computerChoice == 'paper')) {
      setState(() {
        _result = 'You win!';
      });
    } else {
      setState(() {
        _result = 'You lose!';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rock Paper Scissors'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$_result',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () => _play('rock'),
                child: Text('Rock'),
              ),
              ElevatedButton(
                onPressed: () => _play('paper'),
                child: Text('Paper'),
              ),
              ElevatedButton(
                onPressed: () => _play('scissors'),
                child: Text('Scissors'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
