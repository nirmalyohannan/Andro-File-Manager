import 'dart:developer';

import 'package:local_auth/local_auth.dart';

//todo: Add Pin based authentication for BioMetric unavailable devices

Future<bool> authenticate() async {
  final LocalAuthentication auth = LocalAuthentication();
  // ···
  final bool canAuthenticateWithBiometrics = await auth.canCheckBiometrics;
  final bool canAuthenticate =
      canAuthenticateWithBiometrics || await auth.isDeviceSupported();

  if (canAuthenticate) {
    log('::::::::::::Device can authenticate:::::::::');
    final bool didAuthenticate = await auth.authenticate(
        localizedReason: 'Please authenticate to proceed',
        options: const AuthenticationOptions(biometricOnly: true));
    return didAuthenticate;
  } else {
    //todo::: Add SnackBar to show ("No Biometric authentication available, Please add an authentication option from System Setting")
    return false;
  }
}
