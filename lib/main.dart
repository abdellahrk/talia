import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_ce_flutter/adapters.dart';
import 'package:material_3_expressive/material_3_expressive.dart';
import 'package:tasks/route/routes.dart';
import 'package:get_it/get_it.dart';
import 'package:tasks/screen/splash_screen.dart';
import 'package:tasks/screen/task/task_screen.dart';
import 'package:tasks/service/cache_service.dart';
import 'package:tasks/service/db_service.dart';
import 'package:tasks/service/notification_service.dart';
import 'package:tasks/service/task_service.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox("user");
  configureDependencies();

  await getIt<DbService>().opendDb();
  await getIt<NotificationService>().initialise();
  await initializeTimezone();
  runApp(const MyApp());
}

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<CacheService>(CacheService());
  getIt.registerSingleton<TaskService>(TaskService());
  getIt.registerSingleton<DbService>(DbService());
  getIt.registerSingleton<NotificationService>(NotificationService());
}

Future<void> initializeTimezone() async {
  print(tz.timeZoneDatabase.locations.containsKey('Africa/Douala'));
  print(
    tz.timeZoneDatabase.locations.keys
        .where((x) => x.contains('Douala'))
        .toList(),
  );
  final timezone = await FlutterTimezone.getLocalTimezone();

  tz.initializeTimeZones();

  try {
    tz.setLocalLocation(tz.getLocation(timezone.identifier));
  } catch (_) {
    tz.setLocalLocation(tz.getLocation('Etc/GMT-1'));
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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
      autoTheming: true,
      dynamicColoring: true,
      drawUnderSystemBars: true,
      data: M3EThemeData.light(seedColor: Colors.teal),
      home: SplashScreen(),
    );
  }
}
