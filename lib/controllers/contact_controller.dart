import 'package:agenda_eletronica_pessoal/constants/enum/yes_no.dart';
import 'package:agenda_eletronica_pessoal/models/contact.dart';
import 'package:agenda_eletronica_pessoal/services/toast_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:hive/hive.dart';

import '../constants/enum/contact_sort_option.dart';

// Controller para objetos "Contatos".
// Conta com definições padrão para CRUD + busca e listagem de contatos.
class ContactController extends ChangeNotifier {
  final Box hiveBox;
  final ToastService toastService;

  ContactController({required this.hiveBox, required this.toastService});

  String _searchQuery = '';

  ContactSortOption _sortOption = ContactSortOption.nameAsc;

  // Getter da opção atual de ordenação
  ContactSortOption get sortOption => _sortOption;

  // Atualiza o termo a ser pesquisado
  void updateSearchQuery(String query) {
    _searchQuery = query.toLowerCase();
    notifyListeners();
  }

  void updateSortOption(ContactSortOption option) {
    _sortOption = option;
    notifyListeners();
  }

  // Função para recuperar todos os contatos.
  // Retorna um list[] com todos os registros encontrados.
  List<Map<String, dynamic>> fetchContacts() {
    // Recupera as chaves armazenadas
    return hiveBox.keys
        .map((key) {
          // Converte Map(s) em Contact(s)
          final contact = hiveBox.get(key);
          return {
            'key': key,
            'name': contact['name'],
            'surname': contact['surname'],
            'phoneNumber': contact['phoneNumber'],
            'email': contact['email'],
            'createdAt': contact['createdAt'],
            'lastUpdate': contact['lastUpdate'],
          };
        })
        // Retorna uma lista com os contatos em ordem decrescente de adição
        .toList()
        .reversed
        .toList();
  }

  // Filtra os contatos com base no termo de pesquisa
  List<Map<String, dynamic>> get filteredContacts {
    final allContacts = fetchContacts();

    final List<Map<String, dynamic>> foundContacts = _searchQuery.isEmpty
        ? allContacts
        : allContacts.where((contact) {
            final name = (contact['name'] ?? '').toString().toLowerCase();
            final surname = (contact['surname'] ?? '').toString().toLowerCase();
            final phone = (contact['phoneNumber'] ?? '')
                .toString()
                .toLowerCase();
            final email = (contact['email'] ?? '').toString().toLowerCase();

            return name.contains(_searchQuery) ||
                surname.contains(_searchQuery) ||
                phone.contains(_searchQuery) ||
                email.contains(_searchQuery);
          }).toList();

    switch (_sortOption) {
      case ContactSortOption.nameAsc:
        // Ordena A -> Z
        foundContacts.sort(
          (a, b) => (a['name'] ?? '').toString().toLowerCase().compareTo(
            (b['name'] ?? '').toString().toLowerCase(),
          ),
        );
        break;
      case ContactSortOption.nameDesc:
        // Ordena Z -> A
        foundContacts.sort(
          (a, b) => (b['name'] ?? '').toString().toLowerCase().compareTo(
            (a['name'] ?? '').toString().toLowerCase(),
          ),
        );
        break;
      case ContactSortOption.createdAtAsc:
        // Ordena por data de criação mais antiga primeiro
        foundContacts.sort(
          (a, b) => (a['createdAt'] ?? '').toString().compareTo(
            (b['createdAt'] ?? '').toString(),
          ),
        );
        break;
      case ContactSortOption.createdAtDesc:
        // Ordena por data de criação mais recente primeiro
        foundContacts.sort(
          (a, b) => (b['createdAt'] ?? '').toString().compareTo(
            (a['createdAt'] ?? '').toString(),
          ),
        );
        break;
      case ContactSortOption.lastUpdateAsc:
        // Ordena por data de edição mais antiga primeiro
        foundContacts.sort(
          (a, b) => (a['lastUpdate'] ?? '').toString().compareTo(
            (b['lastUpdate'] ?? '').toString(),
          ),
        );
        break;
      case ContactSortOption.lastUpdateDesc:
        // Ordena por data de edição mais recente primeiro
        foundContacts.sort(
          (a, b) => (b['lastUpdate'] ?? '').toString().compareTo(
            (a['lastUpdate'] ?? '').toString(),
          ),
        );
        break;
    }

    return foundContacts;
  }

  // Cria um novo contato no Hive.
  Future<void> createContact({required Contact contact}) async {
    try {
      // Contact >> Map e salva
      await hiveBox.add(contact.toMap());
      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'criar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'criar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Edita um contato, identificação por um contactKey
  Future<void> editContact({
    required Contact contact,
    required int contactKey,
  }) async {
    try {
      // Contact >> Map, busca pela itemKey correspondente e então atualiza o registro
      hiveBox.put(contactKey, contact.toMap());
      //Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'editar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'editar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Deleta um Contato, identificação por um contactKey
  Future<void> deleteContact({required int key}) async {
    try {
      // Busca e deleta o item correspondete ao itemKey
      await hiveBox.delete(key);
      // Invoca um toast de sucesso
      toastService.notifyAfterAction(null, 'deletar', YesNo.yes);
    } catch (e) {
      // Invoca um toast de erro
      toastService.notifyAfterAction(null, 'deletar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }

  // Limpa o armazenamento do Hive
  Future<void> clearContacts() async {
    try {
      // Deleção completa dos dados
      await hiveBox.clear();
      // Invoca um Toast de sucesso
      toastService.notifyAfterAction(null, 'limpar', YesNo.yes);
    } catch (e) {
      // Invoca um Toast de erro
      toastService.notifyAfterAction(null, 'limpar', YesNo.no);
    } finally {
      // Provider para atualização dinâmica da tela
      notifyListeners();
    }
  }
}
