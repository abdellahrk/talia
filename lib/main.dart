import 'package:flutter/material.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:tasks/route/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:tasks/screen/home/home_screen.dart';
import 'package:tasks/screen/splash_screen.dart';
import 'package:tasks/screen/task/task_screen.dart';
import 'package:tasks/screen/widget/bottom_nav.dart';
import 'package:tasks/service/cache_service.dart';
import 'package:tasks/service/db_service.dart';
import 'package:tasks/service/notification_service.dart';
import 'package:tasks/service/task_service.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox("user");
  configureDependencies();

  await getIt<DbService>().opendDb();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<CacheService>(CacheService());
  getIt.registerSingleton<TaskService>(TaskService());
  getIt.registerSingleton<DbService>(DbService());
  getIt.registerSingleton<NotificationService>(NotificationService());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return M3EMaterialApp(
      title: 'Talia',
      routes: routeLists(context),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "/task") {
          final int id = settings.arguments as int;
          return MaterialPageRoute(builder: (context) => TaskScreen(id));
        }
        return null;
      },
      // initialRoute: "/splash",
      // theme: ThemeData(colorScheme: .fromSeed(seedColor: Colors.deepPurple)),
      autoTheming: true,
      dynamicColoring: true,
      drawUnderSystemBars: true,
      data: M3EThemeData.light(seedColor: Colors.teal),
      home: SplashScreen(),
    );
  }
}
