import 'package:agenda_eletronica_pessoal/constants/enum/status.dart';
import 'package:agenda_eletronica_pessoal/constants/enum/yes_no.dart';
import 'package:flutter/material.dart';

// Sistema para notificação global via Toast dentro da aplicação.
// Utilizado principalmente para notificar ações de sucesso ou erro nos Controllers.
class ToastService {
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  /// Pode receber tanto uma mensagem, uma keyword ou apenas um Status.
  ///
  /// Ordem de prioridade: Message > Keyword > Status
  void notifyAfterAction(String? message, String? keyword, YesNo success) {
    if (message != null) {
      Status outcome = success == YesNo.yes ? Status.success : Status.error;
      _notify(msg: message, status: outcome);
    } else if (keyword != null) {
      if (success == YesNo.no) {
        _notify(msg: 'Falha ao tentar $keyword registro', status: Status.error);
      } else {
        _notify(msg: 'Sucesso ao $keyword registro', status: Status.success);
      }
    } else {
      if (success == YesNo.yes) {
        _notify(msg: 'Sucesso', status: Status.success);
      } else {
        _notify(msg: 'Falha', status: Status.error);
      }
    }
    _pop();
  }

  /// Função auxiliar para padronizar invocação de Toasts/SnackBars dentro da aplicação
  void _notify({required String msg, required Status status}) {
    final state = scaffoldMessengerKey.currentState;
    if (state != null) {
      state.clearSnackBars();
      state.showSnackBar(
        SnackBar(
          content: Text(
            msg,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: status == Status.error ? Colors.red : Colors.green,
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  /// Fecha modais (caso tenha algum aberto)
  void _pop() {
    final navigator = navigatorKey.currentState;
    if (navigator != null && navigator.canPop()) {
      navigator.pop();
    }
  }
}
