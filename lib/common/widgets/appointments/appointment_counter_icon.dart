
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';


class AppointmentCounterIcon extends StatelessWidget {
  const AppointmentCounterIcon({
    super.key,
    required this.onpressed,
    required this.iconColor,
  });
  final VoidCallback onpressed;
  final Color iconColor;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          onPressed: onpressed,
          icon: Icon(
            Iconsax.book,
            color: iconColor,
          ),
        ),
        Positioned(
          right: 0,
          child: Container(
            height: 18,
            width: 18,
            decoration: BoxDecoration(
              color:Colors.red ,
              borderRadius: BorderRadius.circular(100),
            ),
            child: Builder(
              builder: (context) {
                return Container();
              }
            ),
          ),
        )
      ],
    );
  }
}
