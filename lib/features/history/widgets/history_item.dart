import 'package:flutter/material.dart';
import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';

class HistoryItem extends StatelessWidget {
  final AttendanceRecord record;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const HistoryItem({
    super.key,
    required this.record,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const Divider(height: 1),
          _buildBody(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: record.isHoliday
            ? kcSecondaryColor.withOpacity(0.1)
            : kcPrimaryColor.withOpacity(0.1),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(12),
          topRight: Radius.circular(12),
        ),
      ),
      child: Row(
        children: [
          Icon(
            record.isHoliday ? Icons.beach_access : Icons.work,
            color: record.isHoliday ? kcSecondaryColor : kcPrimaryColor,
            size: 20,
          ),
          const SizedBox(width: 8),
          Text(
            record.isHoliday ? 'Hari Libur' : 'Hari Kerja',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: record.isHoliday ? kcSecondaryColor : kcPrimaryColor,
            ),
          ),
          const Spacer(),
          Text(
            record.formattedDate,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: kcSecondaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTimeRow(
            'Datang',
            record.formattedCheckInTime,
            Icons.login_rounded,
          ),
          const SizedBox(height: 12),
          _buildTimeRow(
            'Pulang',
            record.formattedCheckOutTime,
            Icons.logout_rounded,
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Total Jam',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kcSecondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${record.totalHours.toStringAsFixed(1)} jam',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcPrimaryTextColor,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'Total Gaji',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: kcSecondaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    record.formattedSalary,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: kcSuccessColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              _buildActionButton(
                'Edit',
                Icons.edit,
                kcPrimaryColor,
                onEdit,
              ),
              const SizedBox(width: 8),
              _buildActionButton(
                'Hapus',
                Icons.delete,
                kcErrorColor,
                onDelete,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimeRow(String label, String time, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: kcPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: kcPrimaryColor,
            size: 16,
          ),
        ),
        const SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: kcSecondaryTextColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              time,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: kcPrimaryTextColor,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActionButton(
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: color,
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
