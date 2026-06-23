import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool isPrimary;
  final IconData? icon;

  const CustomButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.isPrimary = true,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    );
    final padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12);

    if (isPrimary) {
      if (icon != null) {
        return ElevatedButton.icon(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            padding: padding,
            shape: shape,
          ),
          icon: Icon(icon, size: 18),
          label: Text(label),
        );
      }
      return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.primary,
          foregroundColor: theme.colorScheme.onPrimary,
          padding: padding,
          shape: shape,
        ),
        child: Text(label),
      );
    } else {
      if (icon != null) {
        return OutlinedButton.icon(
          onPressed: onPressed,
          style: OutlinedButton.styleFrom(
            padding: padding,
            shape: shape,
            side: BorderSide(color: theme.colorScheme.primary),
            foregroundColor: theme.colorScheme.primary,
          ),
          icon: Icon(icon, size: 18),
          label: Text(label),
        );
      }
      return OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          padding: padding,
          shape: shape,
          side: BorderSide(color: theme.colorScheme.primary),
          foregroundColor: theme.colorScheme.primary,
        ),
        child: Text(label),
      );
    }
  }
}
