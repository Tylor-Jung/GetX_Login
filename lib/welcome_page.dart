import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:getx_login/controller/auth_controller.dart';
import 'package:getx_login/firestore_page.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userEamiladress = FirebaseAuth.instance.currentUser!.email.toString();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Text('Welcome'),
            Text('$userEamiladress'),
            IconButton(
              onPressed: () {
                AuthController.instance.logout();
              },
              icon: Icon(Icons.login_outlined),
            )
          ],
        ),
      ),
    );
  }
}
