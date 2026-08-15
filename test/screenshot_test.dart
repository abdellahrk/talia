library;

import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:golden_screenshot/golden_screenshot.dart';
import 'package:hive_ce/hive_ce.dart';
import 'package:material_ui/material_ui.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:tasks/main.dart';
import 'package:tasks/screen/home/home_screen.dart';
import 'package:tasks/service/cache_service.dart';
import 'package:tasks/service/notification_service.dart';
import 'package:tasks/service/task_service.dart';

import 'app_screenshot_devices.dart';
import 'helpers/db_service_helper.dart';
import 'helpers/fake_task_data.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    sqfliteFfiInit();
    databaseFactory = databaseFactoryFfi;
  });
  setUp(() async {
    await _setupDependencies();
  });

  tearDown(() async {
    await GetIt.instance.reset();
  });

  group('Screenshot', () {
    _screenshot('home', home: const HomeScreen());
  });
}

void _screenshot(
  String description, {
  required Widget home,
  Future<void> Function(WidgetTester tester)? beforeScreenshot,
}) {
  group(description, () {
    for (final goldenDevice in AppScreenshotDevices.values) {
      testGoldens('for ${goldenDevice.name}', (tester) async {
        final device = goldenDevice.device;

        await tester.pumpWidget(ScreenshotApp(device: device, home: home));

        // One of our tests needs to interact with the UI before taking the screenshot.
        await beforeScreenshot?.call(tester);

        // Precache the images and fonts so they're ready for the screenshot.
        await tester.loadAssets();

        // Pump the widget for a second to ensure animations are complete.
        await tester.pumpFrames(
          tester.widget(find.byType(ScreenshotApp)),
          const Duration(seconds: 1),
        );

        // Take the screenshot and compare it to the golden file.
        await tester.expectScreenshot(device, description);
      });
    }
  });
}

Future<void> _setupDependencies() async {
  await GetIt.instance.reset();

  getIt.registerSingleton<NotificationService>(NotificationService());
  getIt.registerSingleton<CacheService>(CacheService());
  getIt.registerSingleton<DbServiceHelper>(DbServiceHelper());

  getIt.registerSingleton<TaskService>(TaskService(getIt<DbServiceHelper>()));

  final directory = Directory('${Directory.systemTemp.path}/talia_golden_test');

  if (!directory.existsSync()) {
    directory.createSync(recursive: true);
  }

  Hive.init(directory.path);

  if (!Hive.isBoxOpen('user')) {
    await Hive.openBox('user');
    Hive.box('user').put('name', 'Rami');
  }

  await getIt<DbServiceHelper>().opendDb();

  final db = getIt<DbServiceHelper>();

  // await db.resetDatabase();
  // await db.resetTestDatabase();
  await populateFakeTasks(db);
}
