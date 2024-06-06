import 'package:booking_calendar/booking_calendar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:graduateproject/views/payment/stripe_payment/payment_manager.dart';
import 'package:intl/intl.dart';
import '../../common/widgets/app_bar/appbar.dart';
import '../../utils/consts/consts.dart';
import '../../features/App/controllers/appointment_controller.dart';

class BookAppointmentView extends StatefulWidget {
  final String docId;
  final String docName;
  final double amount;
  final String Services;

  const BookAppointmentView(
      {super.key,
      required this.docName,
      required this.docId,
      required this.amount,
      required this.Services});

  @override
  State<BookAppointmentView> createState() => _BookAppointmentViewState();
}

class _BookAppointmentViewState extends State<BookAppointmentView> {
  final now = DateTime.now();
  late BookingService mockBookingService;

  List<String> days = [];
  List<int>? numbers;
  List<int>? daysInt;
  DateTime? from = DateTime.now(),
      to = DateTime.now().add(Duration(minutes: 15));
  DateTime Now = DateTime.now();
  var Date = DateFormat("yyyy-MM-dd").format(DateTime.now());
  String datefrom = '';
  String dateto = '';
  int? fromhour, tohour;
  String? Username;
  String? UserId, UserEmail, UserPhonenumber;

  void timefromto(var docto, var docfrom) async {
    datefrom = '$Date ${docfrom.toString()}';
    from = DateTime.parse(datefrom);
    dateto = '$Date ${docto.toString()}';
    to = DateTime.parse(dateto);
    fromhour = from!.hour;
    tohour = to!.hour;
    print(from!.hour.toString() + " ......" + to!.hour.toString());
    print(from.toString() + " ......" + to.toString());
  }

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('doctors')
        .doc(widget.docId)
        .get()
        .then((value) {
      setState(() {
        days = value.data()!['availableDays'].cast<String>();
      });
    }).then((value) {
      numbers = List<int>.filled(days.length, 0);
      for (int i = 0; i < days.length; i++) {
        if (days[i] == 'Sunday') {
          numbers![i] = 7;
        }
        if (days[i] == 'Monday') {
          numbers![i] = 1;
        }
        if (days[i] == 'Tuesday') {
          numbers![i] = 2;
        }
        if (days[i] == 'Wednesday') {
          numbers![i] = 3;
        }
        if (days[i] == 'Thursday') {
          numbers![i] = 4;
        }
        if (days[i] == 'Friday') {
          numbers![i] = 5;
        }
        if (days[i] == 'Saturday') {
          numbers![i] = 6;
        }
      }

      print(numbers.toString() + "hhhhhhhhhhhhhhhhh");

      daysInt = List<int>.filled(7 - days.length, 0);
      int count = 0;
      for (int i = 0; i < 7; i++) {
        if (numbers!.contains(i)) {
        } else {
          setState(() {
            daysInt![count] = i;
            count++;
          });
        }
      }
    });

    if (FirebaseAuth.instance.currentUser != null) {
      UserId = FirebaseAuth.instance.currentUser!.uid;
      UserEmail = FirebaseAuth.instance.currentUser!.email;
      UserPhonenumber = FirebaseAuth.instance.currentUser!.phoneNumber;
    }

    FirebaseFirestore.instance
        .collection('appointments')
        .where('serviceId', isEqualTo: widget.docId)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        var end = DateTime.parse(element.data()['bookingEnd']);
        var start = DateTime.parse(element.data()['bookingStart']);
        converted.add(DateTimeRange(
          end: end,
          start: start,
        ));
      });
    });
  }

  Stream<dynamic>? getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return Stream.value([]);
  }

  Future<dynamic> uploadBookingMock(
      {required BookingService newBooking}) async {
    BookingService book = BookingService(
      bookingStart: newBooking.bookingStart,
      bookingEnd: newBooking.bookingEnd,
      serviceName: widget.Services,
      serviceDuration: newBooking.serviceDuration,
      userId: UserId,
      serviceId: widget.docId,
      servicePrice: widget.amount.toInt(),
      userName: widget.docName,
      userEmail: UserEmail,
      userPhoneNumber: UserPhonenumber,
    );
    try {
      await PaymentManager.makePayment(widget.amount, "egp");
      await Future.delayed(const Duration(seconds: 1));
      converted.add(DateTimeRange(
          start: newBooking.bookingStart, end: newBooking.bookingEnd));
      print(newBooking.bookingEnd.toString() +
          '+++++++....' +
          newBooking.bookingStart.toString());
      print('${book.toJson()} has been uploaded');

      await FirebaseFirestore.instance
          .collection('appointments')
          .add(book.toJson())
          .then((value) =>
              FirebaseFirestore.instance.collection('notifications').add({
                'uid': widget.docId,
                'title': 'HealHive',
                'body':
                    'someone has been make appointment with you,check your schedules!',
                'Date': DateTime.now().toString(),
                'isShow': false,
              }));

      // عرض SnackBar بعد إضافة الحجز بنجاح
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Appointment booked Successfully!'),
          backgroundColor: Colors.lightGreen,
          duration: Duration(seconds: 4),
        ),
      );
    } on FirebaseException catch (e) {
      throw e;
    }
  }

  List<DateTimeRange> converted = [];

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    return converted;
  }

  @override
  Widget build(BuildContext context) {
    print(daysInt.toString() + "build context");
    var controller = Get.put(AppointmnetController());
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBarWidget(
        showBackArrow: true,
        leadingOnPress: () => Get.back(),
        title: Text(
          "Dr ${widget.docName}",
          style: Theme.of(context).textTheme.headlineMedium,
        ),
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('doctors')
              .where('docId', isEqualTo: widget.docId)
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData && snapshot.data.docs.isNotEmpty) {
              timefromto(snapshot.data.docs[0]['docTimingto'],
                  snapshot.data.docs[0]['docTimingfrom']);
            } else {
              return const Text('No data available');
            }
            return Padding(
              padding: const EdgeInsets.all(10.0),
              child: SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: BookingCalendar(
                  availableSlotColor: isDarkMode
                      ? Colors.lightBlue[800]
                      : Colors.lightBlue[300],
                  bookingButtonColor:
                      isDarkMode ? Colors.blue[800] : Colors.blue,
                  selectedSlotColor:
                      isDarkMode ? Colors.amber[800] : Colors.amber,
                  bookingService: BookingService(
                      serviceName: 'Mock Service',
                      serviceDuration: 15,
                      bookingEnd: DateTime(
                          now.year, now.month, now.day, tohour ?? 0, 0),
                      bookingStart: DateTime(
                          now.year, now.month, now.day, fromhour ?? 0, 0)),
                  convertStreamResultToDateTimeRanges: convertStreamResultMock,
                  getBookingStream: getBookingStreamMock,
                  uploadBooking: uploadBookingMock,
                  pauseSlots: generatePauseSlots(),
                  pauseSlotText: 'LUNCH',
                  hideBreakTime: false,
                  loadingWidget: const Text('Fetching data...'),
                  uploadingWidget:
                      const Center(child: CircularProgressIndicator.adaptive()),
                  locale: 'en',
                  startingDayOfWeek: StartingDayOfWeek.saturday,
                  wholeDayIsBookedWidget:
                      const Text('Sorry, for this day everything is booked'),
                  disabledDays: numbers ?? [],
                ),
              ),
            );
          }),
    );
  }

  List<DateTimeRange> generatePauseSlots() {
    return [];
  }
}
