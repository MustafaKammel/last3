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
        numbers = days.map((day) {
          switch (day) {
            case 'Sunday':
              return 7;
            case 'Monday':
              return 1;
            case 'Tuesday':
              return 2;
            case 'Wednesday':
              return 3;
            case 'Thursday':
              return 4;
            case 'Friday':
              return 5;
            case 'Saturday':
              return 6;
            default:
              return 0;
          }
        }).toList();

        daysInt = List<int>.generate(7, (index) => index + 1)
            .where((day) => !numbers!.contains(day))
            .toList();
      });

      if (FirebaseAuth.instance.currentUser != null) {
        UserId = FirebaseAuth.instance.currentUser!.uid;
        UserEmail = FirebaseAuth.instance.currentUser!.email;
        UserPhonenumber = FirebaseAuth.instance.currentUser!.phoneNumber;
      }
    });
  }

  Stream<List<DateTimeRange>> getBookingStreamMock(
      {required DateTime end, required DateTime start}) {
    return FirebaseFirestore.instance
        .collection('appointments')
        .where('serviceId', isEqualTo: widget.docId)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) {
      var data = doc.data();
      return DateTimeRange(
        start: DateTime.parse(data['bookingStart']),
        end: DateTime.parse(data['bookingEnd']),
      );
    }).toList());
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

  List<DateTimeRange> convertStreamResultMock({required dynamic streamResult}) {
    return streamResult;
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
              return StreamBuilder<List<DateTimeRange>>(
                stream: getBookingStreamMock(
                  end: DateTime(now.year, now.month, now.day, tohour ?? 0, 0),
                  start:
                  DateTime(now.year, now.month, now.day, fromhour ?? 0, 0),
                ),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasData) {
                    return Padding(
                      padding: EdgeInsets.all(10.0),
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
                              bookingEnd: DateTime(now.year, now.month, now.day,
                                  tohour ?? 0, 0),
                              bookingStart: DateTime(now.year, now.month,
                                  now.day, fromhour ?? 0, 0)),
                          convertStreamResultToDateTimeRanges:
                          convertStreamResultMock,
                          getBookingStream: getBookingStreamMock,
                          uploadBooking: uploadBookingMock,
                          pauseSlots: generatePauseSlots(),
                          pauseSlotText: 'LUNCH',
                          hideBreakTime: false,
                          loadingWidget: const Text('Fetching data...'),
                          uploadingWidget: Center(
                              child: CircularProgressIndicator.adaptive()),
                          locale: 'en',
                          startingDayOfWeek: StartingDayOfWeek.saturday,
                          wholeDayIsBookedWidget: const Text(
                              'Sorry, for this day everything is booked'),
                          disabledDays: numbers ?? [],
                        ),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return const Center(child: Text('Error loading data'));
                  } else {
                    return const Center(child: Text('No data available'));
                  }
                },
              );
            } else if (snapshot.hasError) {
              return const Center(child: Text('Error loading data'));
            } else {
              return const Center(child: Text('No data available'));
            }
          }),
    );
  }

  List<DateTimeRange> generatePauseSlots() {
    return [];
  }
}
