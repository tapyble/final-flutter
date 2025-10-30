import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:tapyble/src/utils/assets_example.dart';
import 'package:tapyble/src/utils/index.dart';
import 'package:tapyble/src/features/LoginPage/index.dart';
import 'package:tapyble/src/features/HomePage/views/main_container.dart';
import 'package:tapyble/src/common/services/index.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Storage Service
  await StorageService.init();
  
  // Initialize Firebase Auth listener
  FirebaseAuthService.initAuthListener();
  
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {

    print("isLogged in: ${StorageService.isProperlyLoggedIn}");
    return GetMaterialApp(
      title: 'tapyble',
      debugShowCheckedModeBanner: false,
      builder: (BuildContext context, Widget? child) {
        return MediaQuery(
              // ignore: deprecated_member_use
              data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
              child: child!,
            );
      },
      theme: AppFonts.getThemeData(colorScheme: ColorScheme.fromSeed(seedColor: AppColors.zPrimaryBtnColor)),
      initialRoute: StorageService.isProperlyLoggedIn ? '/home' : '/login',
      getPages: [
        GetPage(name: '/login', page: () => const LoginPage()),
        GetPage(name: '/home', page: () => const MainContainer()),
        GetPage(name: '/example', page: () => const AssetsExamplePage()),
      ],
    );
  }
}