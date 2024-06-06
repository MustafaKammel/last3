import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'common/widgets/common_components/wating_screen.dart';
import 'features/App/screens/chat/provider/provider.dart';
import 'utils/constants/text_strings.dart';
import 'utils/theme/theme.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => providerApp(),
        child: Consumer<providerApp>(
          builder: (context, value, child) => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: TTexts.appName,
            themeMode: ThemeMode.system,
            theme: MAppTheme.lightTheme,
            darkTheme: MAppTheme.darkTheme,
            home: const WatingScreen(), //BookingCalendarDemoApp()
          ),
        ));
  }
}
