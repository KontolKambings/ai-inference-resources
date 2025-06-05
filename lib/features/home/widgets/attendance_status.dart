import 'package:flutter/material.dart';
import 'package:gajimu/models/enums/attendance_status.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';

class AttendanceStatusWidget extends StatelessWidget {
  final AttendanceStatus status;

  const AttendanceStatusWidget({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: _getStatusColor().withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: _getStatusColor().withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _getStatusIcon(),
            color: _getStatusColor(),
            size: 24,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              status.label,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: _getStatusColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor() {
    switch (status) {
      case AttendanceStatus.checkedIn:
        return kcSuccessColor;
      case AttendanceStatus.checkedOut:
        return kcSecondaryColor;
      case AttendanceStatus.none:
        return kcSecondaryTextColor;
    }
  }

  IconData _getStatusIcon() {
    switch (status) {
      case AttendanceStatus.checkedIn:
        return Icons.login_rounded;
      case AttendanceStatus.checkedOut:
        return Icons.check_circle_outline_rounded;
      case AttendanceStatus.none:
        return Icons.pending_outlined;
    }
  }
}
