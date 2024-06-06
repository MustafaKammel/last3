import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class photoView extends StatefulWidget {
  const photoView({super.key, required this.image});
  final String image;

  @override
  State<photoView> createState() => _photoViewState();
}

class _photoViewState extends State<photoView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Container(
        child: PhotoView(imageProvider: NetworkImage(widget.image)),
      ),
    );
  }
}
