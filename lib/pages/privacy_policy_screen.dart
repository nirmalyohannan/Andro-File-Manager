import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Lottie.asset('assets/lottie/terms_and_conditions.json',
                  width: MediaQuery.of(context).size.width / 2),
              const Text(
                "Privacy Policy",
                style: TextStyle(fontSize: 55, fontWeight: FontWeight.w500),
              ),
              const SizedBox(
                height: 40,
              ),
              const Text(
                  "The 'Andro File Manager' app uses storage permission from the user for the file manager functionalities.",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 20,
              ),
              const Text(
                  "'Andro File Manager' app will neither misuse the storage permission nor uses it for any other purposes other than the file manager functionalities. The app respects the user privacy and does not collect or send any user data over internet. The app does not connect to any avaialable internet connection.",
                  style: TextStyle(fontSize: 20)),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    ));
  }
}
