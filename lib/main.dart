import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'core/database/db_helper.dart';
import 'core/services/notification_service.dart';
import 'core/services/storage_service.dart';
import 'core/utils/theme.dart';
import 'data/repositories/category_repository.dart';
import 'data/repositories/subtask_repository.dart';
import 'data/repositories/task_repository.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Core Services
  await DatabaseHelper.instance.database;
  await Get.putAsync(() => StorageService().init());

  // Initialize NotificationService
  final notificationService = Get.put(NotificationService());
  // We initialize it here but requests permissions usually on demand or first run
  // For this task requirements "request permissions when needed only" but also "on app launch from notification"
  await notificationService.init();
  // Asking for permission early for better UX in this demo or follow logic in Home/Add Task
  // notificationService.requestPermissions();

  // Determine Initial Route
  final storage = Get.find<StorageService>();
  final bool isFirstLaunch = storage.read<bool>(StorageKeys.isFirstLaunch) ?? true;
  final String initialRoute = isFirstLaunch ? Routes.onboarding : Routes.home;

  runApp(MyApp(initialRoute: initialRoute));
}

class MyApp extends StatelessWidget {
  final String initialRoute;

  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'أنجز',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system, // Respect system setting
      initialBinding: InitialBinding(),
      initialRoute: initialRoute,
      getPages: AppPages.pages,
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(CategoryRepository());
    Get.put(TaskRepository());
    Get.put(SubTaskRepository());
  }
}
