import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:asago/shared/app_strings.dart';

class Timepicker extends StatefulWidget {
  const Timepicker({super.key, this.onTimeSelected});

  final void Function(TimeOfDay)? onTimeSelected;

  @override
  State<Timepicker> createState() => _TimepickerState();
}

class _TimepickerState extends State<Timepicker> {
  late TimeOfDay _selectedTime;

  @override
  void initState() {
    super.initState();
    final box = Hive.box('settings');
    final hour = box.get('departureHour');
    final minute = box.get('departureMinute');
    _selectedTime = (hour != null && minute != null)
        ? TimeOfDay(hour: hour, minute: minute)
        : TimeOfDay.now();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => _selectedTime = picked);
      // Hiveに保存
      final box = Hive.box('settings');
      await box.put('departureHour', picked.hour);
      await box.put('departureMinute', picked.minute);
      widget.onTimeSelected?.call(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;
    final h = _selectedTime.hour.toString().padLeft(2, '0');
    final m = _selectedTime.minute.toString().padLeft(2, '0');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Icon(Icons.access_time_rounded, size: 20, color: cs.primary),
            const SizedBox(width: 8),
            Text(
              AppStrings.departureTimeTitle,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Center(
          child: Text(
            '$h:$m',
            style: GoogleFonts.bizUDGothic(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: cs.primary,
            ),
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: _pickTime,
            icon: const Icon(Icons.edit_outlined, size: 18),
            label: const Text(AppStrings.setTimeButton),
          ),
        ),
      ],
    );
  }
}
