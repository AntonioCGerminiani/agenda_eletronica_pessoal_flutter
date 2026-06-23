import 'package:flutter/material.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_button.dart';

class FormActionButtons extends StatelessWidget {
  final bool isReadOnly;
  final bool isEditing;
  final VoidCallback onClose;
  final VoidCallback onEdit;
  final VoidCallback onCancel;
  final VoidCallback onSubmit;
  final String submitLabel;

  const FormActionButtons({
    super.key,
    required this.isReadOnly,
    required this.isEditing,
    required this.onClose,
    required this.onEdit,
    required this.onCancel,
    required this.onSubmit,
    this.submitLabel = 'Confirmar',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (isReadOnly) ...[
          CustomButton(
            label: 'Fechar',
            onPressed: onClose,
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          CustomButton(
            label: 'Editar',
            onPressed: onEdit,
            isPrimary: true,
            icon: Icons.edit,
          ),
        ] else ...[
          CustomButton(
            label: 'Cancelar',
            onPressed: onCancel,
            isPrimary: false,
          ),
          const SizedBox(width: 12),
          CustomButton(
            label: isEditing ? 'Salvar' : submitLabel,
            onPressed: onSubmit,
            isPrimary: true,
          ),
        ],
      ],
    );
  }
}
