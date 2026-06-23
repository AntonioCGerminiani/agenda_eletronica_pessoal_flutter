import 'package:agenda_eletronica_pessoal/constants/enum/yes_no.dart';
import 'package:agenda_eletronica_pessoal/models/group.dart';
import 'package:agenda_eletronica_pessoal/services/toast_service.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

// Controller para objetos "Grupos".
// Conta com definições padrão para CRUD.
class GroupController extends ChangeNotifier {
  final Box hiveBox;
  final ToastService toastService;

  GroupController({required this.hiveBox, required this.toastService});

  // Função para recuperar todos os grupos.
  // Retorna uma List[] com todos os registros encontrados.
  List<Map<String, dynamic>> fetchGroups() {
    return hiveBox.keys
        .map((key) {
          final group = hiveBox.get(key);
          return {
            'key': key,
            'name': group['name'],
            'contactKeys': group['contactKeys'],
            'createdAt': group['createdAt'],
            'lastUpdate': group['lastUpdate'],
          };
        })
        .toList()
        .reversed
        .toList();
  }

  // Cria um grupo no Hive
  Future<void> createGroup({required Group group}) async {
    try {
      await hiveBox.add(group.toMap());
      toastService.notifyAfterAction(null, 'criar', YesNo.yes);
    } catch (e) {
      toastService.notifyAfterAction(null, 'criar', YesNo.no);
    } finally {
      notifyListeners();
    }
  }

  // Editar um grupo, identifiicação por um groupKey
  Future<void> editGroup({required Group group, required int groupKey}) async {
    try {
      await hiveBox.put(groupKey, group.toMap());
      toastService.notifyAfterAction(null, 'editar', YesNo.yes);
    } catch (e) {
      toastService.notifyAfterAction(null, 'editar', YesNo.no);
    } finally {
      notifyListeners();
    }
  }

  //Deleta um grupo, identicação por um groupKey
  Future<void> deleteGroup({required int key}) async {
    try {
      await hiveBox.delete(key);
      toastService.notifyAfterAction(null, 'deletar', YesNo.yes);
    } catch (e) {
      toastService.notifyAfterAction(null, 'deletar', YesNo.no);
    } finally {
      notifyListeners();
    }
  }

  // Limpa o armazenamento do Hive
  Future<void> clearAllGroups() async {
    try {
      await hiveBox.clear();
      toastService.notifyAfterAction(null, 'limpar', YesNo.yes);
    } catch (e) {
      toastService.notifyAfterAction(null, 'limpar', YesNo.no);
    } finally {
      notifyListeners();
    }
  }
}
