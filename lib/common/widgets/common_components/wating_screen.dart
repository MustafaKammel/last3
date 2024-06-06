import 'package:flutter/material.dart';

import '../../../features/authentication/controllers/auth_controller.dart';

class WatingScreen extends StatefulWidget {
  const WatingScreen({super.key});

  @override
  State<WatingScreen> createState() => _WatingScreenState();
}

class _WatingScreenState extends State<WatingScreen> {
  @override
  void initState() {
    AuthController.isUserAlreadyLoggedIn();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }
}
