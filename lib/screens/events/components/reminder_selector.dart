import 'package:agenda_eletronica_pessoal/constants/enum/reminder_option.dart';
import 'package:flutter/material.dart';

class ReminderSelector extends StatelessWidget {
  final List<int> selectedMinutes;
  final bool isReadOnly;
  final ValueChanged<List<int>> onChanged;

  const ReminderSelector({
    super.key,
    required this.selectedMinutes,
    required this.isReadOnly,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Filtra opções de lembretes que ainda não foram selecionadas
    final availableOptions = ReminderOption.values
        .where((opt) => !selectedMinutes.contains(opt.minutes))
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Lembretes do Evento (${selectedMinutes.length}/3)',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: theme.primaryColor,
              ),
            ),
            if (!isReadOnly && selectedMinutes.length < 3 && availableOptions.isNotEmpty)
              PopupMenuButton<ReminderOption>(
                icon: Icon(Icons.add_alert_outlined, color: theme.primaryColor),
                tooltip: 'Adicionar lembrete',
                onSelected: (option) {
                  final newList = List<int>.from(selectedMinutes)..add(option.minutes);
                  newList.sort();
                  onChanged(newList);
                },
                itemBuilder: (context) {
                  return availableOptions.map((opt) {
                    return PopupMenuItem<ReminderOption>(
                      value: opt,
                      child: Text(opt.label),
                    );
                  }).toList();
                },
              ),
          ],
        ),
        const SizedBox(height: 8),
        if (selectedMinutes.isEmpty)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Nenhum lembrete configurado.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          )
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: selectedMinutes.map((minutes) {
              final option = ReminderOption.fromMinutes(minutes);
              return Chip(
                avatar: Icon(Icons.alarm_on, size: 16, color: theme.primaryColor),
                label: Text(option.label),
                onDeleted: isReadOnly
                    ? null
                    : () {
                        final newList = List<int>.from(selectedMinutes)..remove(minutes);
                        onChanged(newList);
                      },
                deleteIconColor: Colors.redAccent,
                backgroundColor: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
