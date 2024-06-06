// import 'dart:convert';

// import 'package:get/get.dart';
// import 'package:graduateproject/common/widgets/Doctors/doctor_card_vertical.dart';
// import 'package:graduateproject/features/App/screens/Favorite/controller/loaders.dart';
// import 'package:graduateproject/utils/localStorage/storage_utility.dart';

// class FavouritController extends GetxController {
//   static FavouritController get instance => Get.find();

//   final favourit = <String, bool>{}.obs;

//   @override
//   void onInit() {
//     super.onInit();
//     initFavourites();
//   }

//   Future<void> initFavourites() async {
//     final json = TlocalStorage.instance().readData('favorites');
//     if (json != null) {
//       final storedFavourites = jsonDecode(json) as Map<String, dynamic>;
//       storedFavourites.assignAll(
//           storedFavourites.map((key, value) => MapEntry(key, value as bool)));
//     }
//   }

//   bool isFavourite(String productId) {
//     return favourit[productId] ?? false;
//   }

//   void toggleFavouriteProduct(String productId) {
//     if (!favourit.containsKey(productId)) {
//       favourit[productId] = true;
//       saveFavouriteStrorage();
//       Tloaders.customToast(
//           message: 'product has been added from favourite list');
//     } else {
//       TlocalStorage.instance().removeData(productId);
//       favourit.remove(productId);
//       saveFavouriteStrorage();
//       favourit.refresh();
//       Tloaders.customToast(
//           message: 'product has been remove from favorite list ');
//     }
//   }

//   void saveFavouriteStrorage() {
//     final encoddedFavourite = json.encode(favourit);
//     TlocalStorage.instance().saveData('favorites', encoddedFavourite);
//   }
//   // Future <List<DoctorCardVertical>>favoriteProduct()async{
//   //     return await Produc
//   // }
// }
