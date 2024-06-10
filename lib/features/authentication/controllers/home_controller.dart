import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graduateproject/utils/consts/consts.dart';

class HomeController extends GetxController {
  var searchQueryController = TextEditingController();
  var isLoading = false.obs;

  static HomeController get instance => Get.find();

  // variables
  final carsoulCurrentIndex = 0.obs;

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> toggleFavoriteStatus(String docId, bool currentStatus) async {
    try {
      var user = _auth.currentUser;
      if (user == null) return;

      var userRef = _firestore.collection('users').doc(user.uid);
      var doctorRef = _firestore.collection('doctors').doc(docId);
      var favoritesRef = userRef.collection('favorites').doc(docId);

      if (!currentStatus) {
        await favoritesRef.set({'isFavorite': true});
      } else {
        await favoritesRef.delete();
      }

      await doctorRef.update({'isFavorite': !currentStatus});

      update();
    } catch (e) {
      print('Error toggling favorite status: $e');
    }
  }

  Stream<List<String>> getFavoriteDoctors() {
    var user = _auth.currentUser;
    if (user == null) return Stream.value([]);

    return _firestore
        .collection('users')
        .doc(user.uid)
        .collection('favorites')
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  Stream<QuerySnapshot> getDoctorListStream() {
    return FirebaseFirestore.instance.collection('doctors').snapshots();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getDoctorList() async {
    var doctors = FirebaseFirestore.instance.collection('doctors').get();
    return doctors;
  }

  // jump to spasificdot selected page
  void updatePageIndicator(index) {
    carsoulCurrentIndex.value = index;
  }
}
