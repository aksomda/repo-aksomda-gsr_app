import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../../core/theme/gsr_colors.dart';
import '../../../rooms/domain/entities/room.dart';
import '../../../rooms/presentation/bloc/providers/room_provider.dart';
import '../providers/reservation_room_provider.dart';
import '../../../../l10n/l10n_extensions.dart';

/// Formulaire de demande de réservation (agent) : choisir une date/heure,
/// consulter les salles disponibles sur ce créneau, puis en réserver une.
Future<void> showReservationRequestForm(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _ReservationRequestForm(),
  );
}

class _ReservationRequestForm extends StatefulWidget {
  const _ReservationRequestForm();

  @override
  State<_ReservationRequestForm> createState() =>
      _ReservationRequestFormState();
}

class _ReservationRequestFormState extends State<_ReservationRequestForm> {
  final _formKey = GlobalKey<FormState>();
  final _subjectController = TextEditingController();
  final _structureController = TextEditingController();
  DateTime? _date;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  List<Room> _availableRooms = [];
  Room? _selectedRoom;
  bool _isSearching = false;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _subjectController.dispose();
    _structureController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) => DateFormat('yyyy-MM-dd').format(date);
  String _formatTime(TimeOfDay time) =>
      '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _date ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _pickTime({required bool isStart}) async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _searchAvailability() async {
    if (_date == null || _startTime == null || _endTime == null) {
      setState(() => _error = context.l10n.selectDateSlot);
      return;
    }

    final start = _formatTime(_startTime!);
    final end = _formatTime(_endTime!);
    if (start.compareTo(end) >= 0) {
      setState(() => _error = context.l10n.endAfterStart);
      return;
    }

    setState(() {
      _isSearching = true;
      _error = null;
      _selectedRoom = null;
      _availableRooms = [];
    });

    final rooms = await context.read<RoomProvider>().fetchAvailableRooms(
      date: _formatDate(_date!),
      startTime: start,
      endTime: end,
    );

    setState(() {
      _availableRooms = rooms;
      _isSearching = false;
      if (rooms.isEmpty) _error = context.l10n.noRoomAvailable;
    });
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _selectedRoom == null) {
      if (_selectedRoom == null) {
        setState(() => _error = context.l10n.chooseAvailableRoom);
      }
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    final provider = context.read<ReservationRoomProvider>();
    final success = await provider.requestReservation(
      roomId: _selectedRoom!.id!,
      meetingSubject: _subjectController.text.trim(),
      organizingStructure: _structureController.text.trim(),
      date: _formatDate(_date!),
      startTime: _formatTime(_startTime!),
      endTime: _formatTime(_endTime!),
    );

    setState(() => _isSubmitting = false);

    if (!mounted) return;
    if (success) {
      Navigator.of(context).pop();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(context.l10n.requestSent)));
    } else {
      setState(
        () => _error = provider.errorMessage ?? context.l10n.requestFailed,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                context.l10n.newReservationRequest,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: _pickDate,
                      icon: const Icon(Icons.calendar_today, size: 18),
                      label: Text(
                        _date == null ? context.l10n.date : _formatDate(_date!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(isStart: true),
                      icon: const Icon(Icons.schedule, size: 18),
                      label: Text(
                        _startTime == null
                            ? context.l10n.startTime
                            : _formatTime(_startTime!),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => _pickTime(isStart: false),
                      icon: const Icon(Icons.schedule, size: 18),
                      label: Text(
                        _endTime == null
                            ? context.l10n.endTime
                            : _formatTime(_endTime!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: _isSearching ? null : _searchAvailability,
                child: _isSearching
                    ? const SizedBox(
                        height: 18,
                        width: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(context.l10n.viewAvailableRooms),
              ),
              if (_availableRooms.isNotEmpty) ...[
                const SizedBox(height: 12),
                ..._availableRooms.map(
                  (room) => ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(room.name),
                    subtitle: Text('${room.city} - ${room.location}'),
                    leading: Icon(
                      _selectedRoom == room
                          ? Icons.check_circle
                          : Icons.circle_outlined,
                      color: _selectedRoom == room ? GsrColors.primary : null,
                    ),
                    onTap: () => setState(() => _selectedRoom = room),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _subjectController,
                decoration: InputDecoration(
                  labelText: context.l10n.meetingSubject,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.l10n.subjectRequired
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _structureController,
                decoration: InputDecoration(
                  labelText: context.l10n.organizingStructure,
                ),
                validator: (v) => (v == null || v.trim().isEmpty)
                    ? context.l10n.structureRequired
                    : null,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: const TextStyle(color: Colors.red)),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _isSubmitting ? null : _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: GsrColors.primary,
                  foregroundColor: Colors.white,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : Text(context.l10n.sendRequest),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
