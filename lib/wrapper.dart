import 'package:boats_lineseller/views/widgets/loading_indicator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'views/auth_screen/login_screen.dart';
import 'views/home_screen/home.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return loadingIndicator();
        } else if (snapshot.hasData) {
          return const Home();
        }

        return const LoginScreen();
      },
    );
  }
}
