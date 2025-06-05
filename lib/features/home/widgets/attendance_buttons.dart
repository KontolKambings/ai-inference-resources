import 'package:flutter/material.dart';
import 'package:gajimu/models/enums/attendance_status.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/button.dart';

class AttendanceButtons extends StatelessWidget {
  final AttendanceStatus status;
  final bool isHoliday;
  final ValueChanged<bool> onHolidayChanged;
  final VoidCallback onCheckIn;
  final VoidCallback onCheckOut;

  const AttendanceButtons({
    Key? key,
    required this.status,
    required this.isHoliday,
    required this.onHolidayChanged,
    required this.onCheckIn,
    required this.onCheckOut,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _buildDayTypeSelector(),
        const SizedBox(height: 16),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildDayTypeSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          const Text(
            'Jenis Hari:',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
          const Spacer(),
          DropdownButton<bool>(
            value: isHoliday,
            underline: const SizedBox(),
            onChanged: (value) {
              if (value != null) {
                onHolidayChanged(value);
              }
            },
            items: const [
              DropdownMenuItem(
                value: false,
                child: Text(
                  'Hari Kerja',
                  style: TextStyle(
                    color: kcPrimaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              DropdownMenuItem(
                value: true,
                child: Text(
                  'Hari Libur',
                  style: TextStyle(
                    color: kcSecondaryColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    // For checked in status, only show check out button
    if (status == AttendanceStatus.checkedIn) {
      return CustomButton(
        text: 'Pulang',
        icon: Icons.logout_rounded,
        variant: ButtonVariant.primary,
        isFullWidth: true,
        onPressed: onCheckOut,
      );
    }

    // For checked out or no status, show check in button
    // Disable check in if already checked out
    return CustomButton(
      text: 'Datang',
      icon: Icons.login_rounded,
      variant: ButtonVariant.primary,
      isFullWidth: true,
      onPressed: status == AttendanceStatus.checkedOut ? null : onCheckIn,
    );
  }
}
