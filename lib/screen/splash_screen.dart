import 'package:another_flutter_splash_screen/another_flutter_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:tasks/main.dart';
import 'package:tasks/service/cache_service.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return FlutterSplashScreen.fadeIn(
      backgroundColor: Colors.white,
      onInit: () {
        debugPrint("On Init");
      },
      onEnd: () {
        debugPrint("On End");
      },
      childWidget: SizedBox(
        height: 200,
        width: 200,
        child: Text("Splash Screen"),
        //child: Image.asset("assets/dart_bird.png"),
      ),
      useImmersiveMode: true,
      onAnimationEnd: () => debugPrint("On Fade In End"),
      asyncNavigationCallback: () async {
        await Future.delayed(const Duration(seconds: 3));
        final firstTime = getIt<CacheService>().getItem("user", "firstTime");

        if (!context.mounted) return;

        if (null != firstTime && firstTime == false) {
          Navigator.pushReplacementNamed(context, "/");
        }

        Navigator.pushReplacementNamed(context, "/welcome");
      },
    );
  }
}
