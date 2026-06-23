import 'package:agenda_eletronica_pessoal/constants/app_colors.dart';
import 'package:agenda_eletronica_pessoal/constants/app_strings.dart';
import 'package:agenda_eletronica_pessoal/controllers/contact_controller.dart';
import 'package:agenda_eletronica_pessoal/controllers/event_controller.dart';
import 'package:agenda_eletronica_pessoal/controllers/group_controller.dart';
import 'package:agenda_eletronica_pessoal/screens/home/home_screen.dart';
import 'package:agenda_eletronica_pessoal/services/hive_service.dart';
import 'package:agenda_eletronica_pessoal/services/notification_service.dart';
import 'package:agenda_eletronica_pessoal/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  // Certifica que os widgets do Flutter estejam prontos para uso
  WidgetsFlutterBinding.ensureInitialized();

  //Inicialização do banco de dados Hive
  await HiveService.init();

  await NotificationService().init();

  final toastService = ToastService();

  runApp(
    MultiProvider(
      providers: [
        Provider<ToastService>.value(value: toastService),
        ChangeNotifierProvider(
          create: (context) => ContactController(
            hiveBox: Hive.box(AppStrings.contactsBox),
            toastService: toastService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => GroupController(
            hiveBox: Hive.box(AppStrings.groupsBox),
            toastService: toastService,
          ),
        ),
        ChangeNotifierProvider(
          create: (context) => EventController(
            hiveBox: Hive.box(AppStrings.eventsBox),
            toastService: toastService,
            notificationService: NotificationService(),
          ),
        ),
      ],
      child: MaterialApp(
        navigatorKey: toastService.navigatorKey,
        scaffoldMessengerKey: toastService.scaffoldMessengerKey,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            primary: AppColors.primary,
            secondary: AppColors.secondary,
            error: AppColors.error,
            surface: AppColors.surface,
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            centerTitle: true,
          ),
          scaffoldBackgroundColor: AppColors.background,
        ),
        home: const HomeScreen(),
      ),
    ),
  );
}
