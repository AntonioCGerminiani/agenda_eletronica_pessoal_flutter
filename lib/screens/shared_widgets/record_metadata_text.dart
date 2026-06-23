import 'package:flutter/material.dart';
import 'package:agenda_eletronica_pessoal/utils/date_output_formatter.dart';

// Widget para apresentação das datas de criação e última edição dos registros
class RecordMetadataText extends StatelessWidget {
  final String? createdAt;
  final String? updatedAt;
  final bool isReadOnly;
  final bool isEditing;

  const RecordMetadataText({
    super.key,
    required this.createdAt,
    required this.updatedAt,
    required this.isReadOnly,
    required this.isEditing,
  });

  @override
  Widget build(BuildContext context) {
    if (!isEditing && !isReadOnly) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: double.infinity,
          child: Text(
            'Criado em: ${DateOutputFormatter.formatDate(createdAt)}\n'
            'Editado em: ${DateOutputFormatter.formatDate(updatedAt)}',
            style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
          ),
        ),
        const SizedBox(height: 10),
      ],
    );
  }
}
