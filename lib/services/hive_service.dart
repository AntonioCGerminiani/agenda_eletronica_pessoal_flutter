import 'package:agenda_eletronica_pessoal/constants/app_strings.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    // Inicializa o Hive
    await Hive.initFlutter();
    // Abre as "caixas" do Hive para armazenamento persistente
    await Hive.openBox(AppStrings.contactsBox);
    await Hive.openBox(AppStrings.groupsBox);
    await Hive.openBox(AppStrings.eventsBox);
  }
}
