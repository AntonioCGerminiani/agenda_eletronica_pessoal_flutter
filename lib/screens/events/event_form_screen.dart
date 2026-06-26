import 'package:agenda_eletronica_pessoal/controllers/event_controller.dart';
import 'package:agenda_eletronica_pessoal/models/event.dart';
import 'package:agenda_eletronica_pessoal/screens/events/components/participants_selector.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/custom_text_field.dart';
import 'package:agenda_eletronica_pessoal/screens/events/components/reminder_selector.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:agenda_eletronica_pessoal/screens/shared_widgets/modal_bottom_sheet_layout.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/bottom_sheet_header.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/form_action_buttons.dart';
import 'package:agenda_eletronica_pessoal/screens/shared_widgets/record_metadata_text.dart';

class EventFormScreen extends StatefulWidget {
  final Event? event;
  final int? eventKey;

  const EventFormScreen({super.key, this.event, this.eventKey});

  @override
  State<EventFormScreen> createState() => _EventFormScreenState();
}

class _EventFormScreenState extends State<EventFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _dateController;
  late TextEditingController _timeController;

  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  // Lista local para gerenciar os contatos selecionados durante a edição do formulário
  late List<int> _selectedContactKeys;
  // Lista local para gerenciar os lembretes do evento
  late List<int> _selectedReminderMinutes;
  late bool _isReadOnly;

  bool get _isEditing => widget.event != null;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.event?.name ?? '');
    _dateController = TextEditingController(text: widget.event?.date ?? '');
    _timeController = TextEditingController(text: widget.event?.time ?? '');

    // Inicializa a lista de selecionados clonando do evento existente ou vazia se for novo
    _selectedContactKeys = widget.event != null
        ? List<int>.from(widget.event!.contactKeys)
        : [];

    _selectedReminderMinutes = widget.event != null
        ? List<int>.from(widget.event!.reminderMinutes)
        : [];

    // Tenta fazer o parse dos valores existentes de data e hora
    if (widget.event != null) {
      final dateParts = widget.event!.date.split('/');
      if (dateParts.length == 3) {
        _selectedDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
      }

      final timeParts = widget.event!.time.split(':');
      if (timeParts.length == 2) {
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }

    // Se o evento foi passado, começamos no modo somente leitura
    _isReadOnly = widget.event != null;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  // Restaura o formulário para os valores originais caso o usuário cancele a edição
  void _resetForm() {
    if (widget.event != null) {
      _nameController.text = widget.event!.name;
      _dateController.text = widget.event!.date;
      _timeController.text = widget.event!.time;
      _selectedContactKeys = List<int>.from(widget.event!.contactKeys);
      _selectedReminderMinutes = List<int>.from(widget.event!.reminderMinutes);

      final dateParts = widget.event!.date.split('/');
      if (dateParts.length == 3) {
        _selectedDate = DateTime(
          int.parse(dateParts[2]),
          int.parse(dateParts[1]),
          int.parse(dateParts[0]),
        );
      }

      final timeParts = widget.event!.time.split(':');
      if (timeParts.length == 2) {
        _selectedTime = TimeOfDay(
          hour: int.parse(timeParts[0]),
          minute: int.parse(timeParts[1]),
        );
      }
    }
    setState(() {
      _isReadOnly = true;
    });
  }

  // Abre o Date Picker para seleção da data
  Future<void> _selectDate() async {
    if (_isReadOnly) return;
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
        _dateController.text =
            "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  // Abre o Time Picker no formato dial para seleção do horário
  Future<void> _selectTime() async {
    if (_isReadOnly) return;
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
      initialEntryMode: TimePickerEntryMode.dial,
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  // Salva ou atualiza o evento no banco
  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final date = _dateController.text.trim();
    final time = _timeController.text.trim();
    // ---
    // Uso de Provider para evitar 'prop-drilling' e manter widget otimizado.
    // "listen: false": widget não é reconstruído conforme EventController atualiza,
    // somente utiliza a instância para realizar uma ação pontual.
    final eventController = Provider.of<EventController>(
      context,
      listen: false,
    );
    // ---

    if (_isEditing) {
      final updatedEvent = widget.event!.copyWith(
        name: name,
        date: date,
        time: time,
        contactKeys: _selectedContactKeys,
        reminderMinutes: _selectedReminderMinutes,
      );
      eventController.editEvent(
        event: updatedEvent,
        eventKey: widget.eventKey!,
      );
    } else {
      final newEvent = Event(
        name: name,
        date: date,
        time: time,
        contactKeys: _selectedContactKeys,
        reminderMinutes: _selectedReminderMinutes,
      );
      eventController.createEvent(event: newEvent);
    }
  }



  @override
  Widget build(BuildContext context) {

    // Definição dinâmica do título e ícone
    String titleText;
    IconData headerIcon;
    if (_isReadOnly) {
      titleText = 'Detalhes do Evento';
      headerIcon = Icons.event_note_outlined;
    } else if (_isEditing) {
      titleText = 'Editar Evento';
      headerIcon = Icons.edit_calendar_outlined;
    } else {
      titleText = 'Novo Evento';
      headerIcon = Icons.event_available_outlined;
    }



    return ModalBottomSheetLayout(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          BottomSheetHeader(icon: headerIcon, title: titleText),
          Flexible(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      controller: _nameController,
                      labelText: 'Nome do Evento',
                      prefixIcon: Icons.event_note_outlined,
                      readOnly: _isReadOnly,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Insira o nome do evento';
                        }
                        return null;
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _selectDate,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: _dateController,
                                labelText: 'Data do Evento',
                                prefixIcon: Icons.calendar_today_outlined,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Selecione a data';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: GestureDetector(
                            onTap: _selectTime,
                            child: AbsorbPointer(
                              child: CustomTextField(
                                controller: _timeController,
                                labelText: 'Horário',
                                prefixIcon: Icons.access_time_outlined,
                                readOnly: true,
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Selecione a hora';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ReminderSelector(
                      selectedMinutes: _selectedReminderMinutes,
                      isReadOnly: _isReadOnly,
                      onChanged: (newMinutes) {
                        setState(() {
                          _selectedReminderMinutes = newMinutes;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    ParticipantsSelector(
                      selectedContactKeys: _selectedContactKeys,
                      isReadOnly: _isReadOnly,
                      onChanged: (newContactKeys) {
                        setState(() {
                          _selectedContactKeys = newContactKeys;
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    RecordMetadataText(
                      createdAt: widget.event?.createdAt,
                      updatedAt: widget.event?.lastUpdate,
                      isReadOnly: _isReadOnly,
                      isEditing: _isEditing,
                    ),
                    FormActionButtons(
                      isReadOnly: _isReadOnly,
                      isEditing: _isEditing,
                      onClose: () => Navigator.of(context).pop(),
                      onEdit: () {
                        setState(() {
                          _isReadOnly = false;
                        });
                      },
                      onCancel: () {
                        if (_isEditing) {
                          _resetForm();
                        } else {
                          Navigator.of(context).pop();
                        }
                      },
                      onSubmit: _submit,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
