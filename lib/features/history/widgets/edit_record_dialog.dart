import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/button.dart';
import 'package:gajimu/shared/text_style.dart';

class EditRecordDialog extends StatefulWidget {
  final AttendanceRecord record;
  final Function(AttendanceRecord) onSave;

  const EditRecordDialog({
    super.key,
    required this.record,
    required this.onSave,
  });

  @override
  State<EditRecordDialog> createState() => _EditRecordDialogState();
}

class _EditRecordDialogState extends State<EditRecordDialog> {
  late DateTime _checkInDate;
  late TimeOfDay _checkInTime;
  late DateTime? _checkOutDate;
  late TimeOfDay? _checkOutTime;
  late bool _isHoliday;

  @override
  void initState() {
    super.initState();
    _checkInDate = widget.record.checkInTime;
    _checkInTime = TimeOfDay(
      hour: widget.record.checkInTime.hour,
      minute: widget.record.checkInTime.minute,
    );

    if (widget.record.checkOutTime != null) {
      _checkOutDate = widget.record.checkOutTime;
      _checkOutTime = TimeOfDay(
        hour: widget.record.checkOutTime!.hour,
        minute: widget.record.checkOutTime!.minute,
      );
    } else {
      _checkOutDate = null;
      _checkOutTime = null;
    }

    _isHoliday = widget.record.isHoliday;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Edit Riwayat Absensi',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: kcPrimaryTextColor,
              ),
            ),
            const SizedBox(height: 20),
            _buildDateTimeSection(
              'Waktu Datang',
              _checkInDate,
              _checkInTime,
              (date) {
                setState(() => _checkInDate = date);
              },
              (time) {
                setState(() => _checkInTime = time);
              },
            ),
            const SizedBox(height: 16),
            _buildDateTimeSection(
              'Waktu Pulang',
              _checkOutDate,
              _checkOutTime,
              (date) {
                setState(() => _checkOutDate = date);
              },
              (time) {
                setState(() => _checkOutTime = time);
              },
              isRequired: false,
            ),
            const SizedBox(height: 16),
            _buildHolidayToggle(),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    'Batal',
                    style: TextStyle(
                      color: kcSecondaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                CustomButton(
                  text: 'Simpan',
                  variant: ButtonVariant.primary,
                  onPressed: _saveChanges,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDateTimeSection(
    String label,
    DateTime? date,
    TimeOfDay? time,
    Function(DateTime) onDateChanged,
    Function(TimeOfDay) onTimeChanged, {
    bool isRequired = true,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kcPrimaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: InkWell(
                onTap: () => _selectDate(context, date, onDateChanged),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: kcSecondaryTextColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        size: 18,
                        color: kcPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        date != null
                            ? DateFormat('dd/MM/yyyy').format(date)
                            : isRequired
                                ? 'Pilih Tanggal'
                                : 'Opsional',
                        style: TextStyle(
                          color: date != null
                              ? kcPrimaryTextColor
                              : kcSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: InkWell(
                onTap: () => _selectTime(context, time, onTimeChanged),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(
                        color: kcSecondaryTextColor.withOpacity(0.3)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 18,
                        color: kcPrimaryColor,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        time != null
                            ? time.format(context)
                            : isRequired
                                ? 'Pilih Waktu'
                                : 'Opsional',
                        style: TextStyle(
                          color: time != null
                              ? kcPrimaryTextColor
                              : kcSecondaryTextColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildHolidayToggle() {
    return Row(
      children: [
        Switch(
          value: _isHoliday,
          activeColor: kcPrimaryColor,
          onChanged: (value) {
            setState(() {
              _isHoliday = value;
            });
          },
        ),
        const SizedBox(width: 8),
        const Text(
          'Hari Libur',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: kcPrimaryTextColor,
          ),
        ),
      ],
    );
  }

  Future<void> _selectDate(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onDateChanged,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initialDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kcPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onDateChanged(picked);
    }
  }

  Future<void> _selectTime(
    BuildContext context,
    TimeOfDay? initialTime,
    Function(TimeOfDay) onTimeChanged,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initialTime ?? TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: kcPrimaryColor,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      onTimeChanged(picked);
    }
  }

  void _saveChanges() {
    // Combine date and time for check-in
    final checkInDateTime = DateTime(
      _checkInDate.year,
      _checkInDate.month,
      _checkInDate.day,
      _checkInTime.hour,
      _checkInTime.minute,
    );

    // Combine date and time for check-out if available
    DateTime? checkOutDateTime;
    if (_checkOutDate != null && _checkOutTime != null) {
      checkOutDateTime = DateTime(
        _checkOutDate!.year,
        _checkOutDate!.month,
        _checkOutDate!.day,
        _checkOutTime!.hour,
        _checkOutTime!.minute,
      );
    }

    // Create updated record
    final updatedRecord = widget.record.copyWith(
      checkInTime: checkInDateTime,
      checkOutTime: checkOutDateTime,
      isHoliday: _isHoliday,
    );

    widget.onSave(updatedRecord);
    Navigator.of(context).pop();
  }
}
