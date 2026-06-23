import 'package:flutter/material.dart';

class DeleteConfirmationDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? boldText;
  final String confirmLabel;
  final String cancelLabel;
  final VoidCallback onConfirm;
  final Color? confirmColor;
  final IconData icon;

  const DeleteConfirmationDialog({
    super.key,
    required this.title,
    required this.message,
    this.boldText,
    this.confirmLabel = 'Excluir',
    this.cancelLabel = 'Cancelar',
    required this.onConfirm,
    this.confirmColor,
    this.icon = Icons.warning_amber_rounded,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      icon: Icon(
        icon,
        color: confirmColor ?? theme.colorScheme.error,
        size: 40,
      ),
      title: Text(
        title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          style: theme.textTheme.bodyMedium,
          children: [
            TextSpan(text: message),
            if (boldText != null) ...[
              const TextSpan(text: ' '),
              TextSpan(
                text: boldText,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
            const TextSpan(text: '?'),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceEvenly,
      actions: [
        OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(cancelLabel),
        ),
        ElevatedButton(
          onPressed: () {
            onConfirm();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: confirmColor ?? theme.colorScheme.error,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(confirmLabel),
        ),
      ],
    );
  }
}
