// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// enum ThemeModeEnum { light, dark }
//
// class ThemeDarkModeNotifier extends StateNotifier<ThemeModeEnum> {
//   ThemeDarkModeNotifier() : super(ThemeModeEnum.light);
//
//   void selectMode() {
//     state = state == ThemeModeEnum.light ? ThemeModeEnum.dark : ThemeModeEnum.light;
//   }
// }
//
// final themeDarkMode = StateNotifierProvider<ThemeDarkModeNotifier, ThemeModeEnum>((ref) {
//   return ThemeDarkModeNotifier();
// });
//
// class HomeScreenPro extends ConsumerWidget {
//   const HomeScreenPro({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Dark Mode Example2'),
//       ),
//       body: Center(
//         child: ElevatedButton(
//           onPressed: () {
//             ref.read(themeDarkMode.notifier).selectMode();
//           },
//           child: const Text('Toggle Theme'),
//         ),
//       ),
//     );
//   }
// }
//
// class Ho2 extends StatelessWidget {
//   const Ho2({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(),
//     );
//   }
// }
//
// class App3 extends ConsumerWidget {
//   const App3({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final themeDarkMode = ref.watch(themeDarkMode);
//     return MaterialApp(
//       theme: ThemeData(
//         brightness: themeDarkMode == ThemeModeEnum.light ? Brightness.light : Brightness.dark,
//         // Define your light mode theme colors here
//       ),
//       darkTheme: ThemeData(
//         brightness: Brightness.dark,
//         // Define your dark mode theme colors here
//       ),
//       home: const HomeScreenPro(),
//     );
//   }
// }