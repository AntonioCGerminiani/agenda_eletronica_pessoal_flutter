import 'package:flutter/material.dart';

class ModalBottomSheetLayout extends StatelessWidget {
  final Widget child;

  const ModalBottomSheetLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: keyboardSpace),
      child: Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.90,
          maxWidth: MediaQuery.of(context).size.width * 0.95,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
        ),
        child: child,
      ),
    );
  }
}
