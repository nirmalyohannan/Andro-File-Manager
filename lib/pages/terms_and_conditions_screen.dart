import 'package:androfilemanager/pages/splash_screen.dart';
import 'package:flutter/material.dart';

class TermsAndCondtionScreen extends StatefulWidget {
  const TermsAndCondtionScreen({super.key});

  @override
  State<TermsAndCondtionScreen> createState() => _TermsAndCondtionScreenState();
}

class _TermsAndCondtionScreenState extends State<TermsAndCondtionScreen> {
  bool checkBoxValue = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Terms and Conditions",
              style: TextStyle(fontSize: 55, fontWeight: FontWeight.w500),
            ),
            const SizedBox(
              height: 60,
            ),
            const Text(
                "The 'Andro File Manager' app requires storage permission from the user for the file manager functionalities.",
                style: TextStyle(fontSize: 20)),
            const Text(
                "'Andro File Manager' app will not misuse the storage permission. The app respects the user privacy and does not collect or send any user data over internet. The app does not connect to any avaialable internet connection.",
                style: TextStyle(fontSize: 20)),
            Row(
              children: [
                Checkbox(
                  checkColor: Colors.blue,
                  value: checkBoxValue,
                  onChanged: (value) {
                    setState(() {
                      checkBoxValue = value! ? true : false;
                    });
                  },
                ),
                const Text("Access storage",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800))
              ],
            ),
            Visibility(
                visible: checkBoxValue,
                child: ElevatedButton(
                    onPressed: () async {
                      await prefs.setBool("isFirstTime", true);
                      // ignore: use_build_context_synchronously
                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
                        builder: (context) {
                          return const SplashScreen();
                        },
                      ), (route) => false);
                    },
                    child: const Text("Continue")))
          ],
        ),
      ),
    ));
  }
}
