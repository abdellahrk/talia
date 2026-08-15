import 'package:material_ui/material_ui.dart';
import 'package:tasks/main.dart';
import 'package:tasks/service/cache_service.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

@override
void initState() {
  getIt<CacheService>().putItem("user", "firstTime", false);
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Intro Screen")));
  }
}
