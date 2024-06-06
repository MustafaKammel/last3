import 'package:flutter/material.dart';
import 'package:graduateproject/views/payment/stripe_payment/payment_manager.dart';

class MyCard extends StatelessWidget {
  const MyCard({super.key, required this.amount});
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Center(
          child: Icon(Icons.arrow_back),
        ),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "My card",
          textAlign: TextAlign.center,
        ),
        backgroundColor: Colors.cyan,
      ),
      body: Column(
        children: [
          const SizedBox(
            height: 60,
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                "appointment cost",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
          ),
          Center(
              child: Padding(
            padding: const EdgeInsets.only(top: 10),
            child: Text(
              "$amount LE",
              style: const TextStyle(color: Colors.green, fontSize: 20),
            ),
          )),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 40),
              child: Text(
                " Discount ",
                style: TextStyle(color: Colors.black, fontSize: 24),
              ),
            ),
          ),
          const Center(
            child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Text(
                "0 LE",
                style: TextStyle(color: Colors.green, fontSize: 20),
              ),
            ),
          ),
          const SizedBox(
            height: 30,
          ),
          Container(
            width: 320,
            decoration: const ShapeDecoration(
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    width: 1,
                    strokeAlign: BorderSide.strokeAlignCenter,
                    color: Colors.blueAccent),
              ),
            ),
          ),
          Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 40),
                    child: Text(
                      " Total ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 27,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
              const Spacer(
                flex: 1,
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Text(
                      "$amount LE",
                      style: const TextStyle(
                          color: Colors.green,
                          fontSize: 25,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () => PaymentManager.makePayment(amount, "egp"),
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Container(
                width: 350,
                height: 73,
                decoration: ShapeDecoration(
                  color: const Color(0xFF34A853),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Center(
                  child: Text(
                    'Complete Appointment',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 22,
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.w500,
                      height: 0,
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
