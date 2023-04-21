import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class TermsAndCondtionScreen extends StatefulWidget {
  const TermsAndCondtionScreen({super.key});

  @override
  State<TermsAndCondtionScreen> createState() => _TermsAndCondtionScreenState();
}

class _TermsAndCondtionScreenState extends State<TermsAndCondtionScreen> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Lottie.asset('assets/lottie/terms_and_conditions.json',
                    width: MediaQuery.of(context).size.width / 2),
                const Text(
                  "Terms & Conditions",
                  style: TextStyle(fontSize: 55, fontWeight: FontWeight.w500),
                ),
                const SizedBox(
                  height: 40,
                ),
                const Text(
                    "The 'Andro File Manager' app requires storage permission from the user for the file manager functionalities.",
                    style: TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 20,
                ),
                const Text(
                    "'Andro File Manager' app will not misuse the storage permission. The app respects the user privacy and does not collect or send any user data over internet. The app does not connect to any avaialable internet connection.",
                    style: TextStyle(fontSize: 20)),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Switch(
                      value: checkBoxValue,
                      onChanged: (value) {
                        setState(() {
                          checkBoxValue = value ? true : false;
                        });
                      },
                    ),
                    const Flexible(
                      child: Text("I hereby accepts the Terms and Conditions",
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w500)),
                    )
                  ],
                ),
                const Spacer(),
                Visibility(
                    visible: checkBoxValue,
                    child: ElevatedButton(
                        onPressed: () async {
                          await prefs.setBool("isFirstTime", true);
                          // ignore: use_build_context_synchronously
                          Navigator.pushAndRemoveUntil(context,
                              MaterialPageRoute(
                            builder: (context) {
                              return const SplashScreen();
                            },
                          ), (route) => false);
                        },
                        child: const Text("Continue"))),
                const SizedBox(
                  height: 30,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
