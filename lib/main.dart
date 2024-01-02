import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:i_have_todo/app/Components/customloader.dart';
import 'package:i_have_todo/app/constants/them_data.dart';
import 'package:i_have_todo/app/features/Home/view/home_view.dart';
import 'package:i_have_todo/app/services/notification_service.dart';
import 'package:i_have_todo/firebase_options.dart';
import 'package:lottie/lottie.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
  configLoading();
}

void configLoading() {
  EasyLoading.instance
    ..displayDuration = const Duration(milliseconds: 2000)
    ..indicatorType = EasyLoadingIndicatorType.wave
    ..loadingStyle = EasyLoadingStyle.light
    ..indicatorSize = 20.0
    ..radius = 0.0
    ..maskColor = Colors.white.withOpacity(0.5)
    ..backgroundColor = Colors.transparent
    ..indicatorColor = kPrimaryColor
    ..userInteractions = true
    ..dismissOnTap = false
    ..customAnimation = CustomAnimation();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    NotificationService().init();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: kPrimaryColor,
      statusBarIconBrightness: Brightness.light,
    ));
    return MaterialApp(
      title: 'Todo.',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      home: const Splash(),
      builder: EasyLoading.init(),
    );
  }
}

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kPrimaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animations/Animation - 1704183914546.json',
              width: 200,
              height: 200,
              fit: BoxFit.cover,
              onLoaded: (composition) {
                Future.delayed(const Duration(seconds: 2), () {
                  final route =
                      MaterialPageRoute(builder: (context) => const HomeView());
                  Navigator.pushReplacement(context, route, result: (_) {});
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
