import 'package:agenda_eletronica_pessoal/screens/contacts/components/dynamic_contact_avatar.dart';
import 'package:flutter/material.dart';

class CustomListTile extends StatelessWidget {
  final String name;
  final String aditionalText;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;

  const CustomListTile({
    super.key,
    required this.name,
    required this.aditionalText,
    this.onTap,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final parts = name.trim().split(RegExp(r'\s+'));
    final String first = parts.isNotEmpty ? parts.first : '';
    final String last = parts.length > 1 ? parts.last : '';

    return ListTile(
      leading: DynamicContactAvatar(name: first, surname: last),
      title: Text(name),
      subtitle: Text(aditionalText),
      onTap: onTap,
      trailing: onDelete != null
          ? IconButton(
              icon: Icon(
                Icons.delete,
                color: Theme.of(context).colorScheme.error,
              ),
              onPressed: onDelete,
            )
          : null,
    );
  }
}
