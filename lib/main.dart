import 'package:material_ui/material_ui.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:hive_ce_flutter/adapters.dart';
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

  await initializeApp();

  runApp(const MyApp());
}

final getIt = GetIt.instance;

void configureDependencies() {
  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<CacheService>(CacheService());
  getIt.registerSingleton<DbService>(DbService());

  getIt.registerSingleton<TaskService>(TaskService(getIt<DbService>()));
}

Future<void> initializeApp() async {
  await Hive.initFlutter();

  if (!Hive.isBoxOpen('user')) {
    await Hive.openBox('user');
  }

  await initializeTimezone();

  configureDependencies();

  getIt<DbService>().opendDb();
  getIt<NotificationService>().initialise();
}

Future<void> initializeTimezone() async {
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
    return MaterialApp(
      title: 'Talia',
      routes: routeLists(context),
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == "/task") {
          final int id = settings.arguments as int;
          return MaterialPageRoute(builder: (context) => TaskScreen(id));
        }
        return null;
      },
      // autoTheming: true,
      // dynamicColoring: true,
      // drawUnderSystemBars: true,
      // data: M3EThemeData.light(seedColor: Colors.teal),
      home: SplashScreen(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          primary: Colors.teal,
        ),
        useMaterial3: true,
        listTileTheme: ListTileThemeData(),
      ),
    );
  }
}
