import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyAU-jAMqynLl0lUmV0cx0In5bG4TSMK5Lc",
            authDomain: "vuka265-6z79ng.firebaseapp.com",
            projectId: "vuka265-6z79ng",
            storageBucket: "vuka265-6z79ng.firebasestorage.app",
            messagingSenderId: "236422576815",
            appId: "1:236422576815:web:946af18c818798092bb25a",
            measurementId: "G-WDS37X213T"));
  } else {
    await Firebase.initializeApp();
  }
}
