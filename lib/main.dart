import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shopping/app.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shopping/data/repositories/authentication/authentication_repository.dart';
import 'package:shopping/firebase_options.dart';

Future<void> main() async {
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();

//getx local storage
  await GetStorage.init();

  //await splash screen
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

//Initialize Authentication
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform)
      .then((FirebaseApp value) => Get.put(AuthenticationRepository()));

  runApp(const App());
}
