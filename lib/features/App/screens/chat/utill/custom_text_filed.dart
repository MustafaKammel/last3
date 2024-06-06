import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class custum_text_field extends StatefulWidget {
  final String lable;
  final IconData icon;
  final TextEditingController controller;
  final bool ispass;
  final String Hinttext;

  const custum_text_field({super.key,
    required this.lable,
    required this.icon,
    required this.controller,
    this.ispass=false,
    required this.Hinttext,
  });

  @override
  State<custum_text_field> createState() => _custum_text_fieldState();
}

class _custum_text_fieldState extends State<custum_text_field> {
  bool obsecure=true;
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: const EdgeInsets.only(top: 20,bottom: 12),
      child: TextFormField(
        validator: widget.ispass ==true ?
            (value) => value!.isEmpty ? "the pass is required " : null
            : (value) => value!.isEmpty ? "the email is required" : null ,
        controller:  widget.controller,
        obscureText: widget.ispass==true ? obsecure:false,

        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 25),
          hintText: widget.Hinttext,

          labelText: widget.lable,
          prefix: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: Icon(widget.icon),
          ),
          suffix: widget.ispass ? IconButton(onPressed: (){
            setState(() {
              obsecure= !obsecure;
            });
          },
              icon: const Icon(Iconsax.eye3))
              : const SizedBox(),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(color: Color(0xff11F4E1)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
