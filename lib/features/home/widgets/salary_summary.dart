import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';

class SalarySummary extends StatelessWidget {
  final AttendanceRecord? currentRecord;
  final TimeService timeService;

  const SalarySummary({
    super.key,
    required this.currentRecord,
    required this.timeService,
  });

  @override
  Widget build(BuildContext context) {
    final hasCheckedIn = currentRecord != null;
    final hasCheckedOut = currentRecord?.checkOutTime != null;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Kerja Hari Ini',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kcPrimaryTextColor,
            ),
          ),
          const SizedBox(height: 16),
          _buildInfoRow(
            'Jam Kerja',
            hasCheckedIn ? _calculateWorkHours() : 'Belum melakukan absensi',
            Icons.access_time,
          ),
          const Divider(height: 24),
          _buildInfoRow(
            'Total Gaji',
            hasCheckedIn && hasCheckedOut
                ? _formatSalary(currentRecord!.totalSalary)
                : 'Rp0',
            Icons.monetization_on_outlined,
          ),
          if (hasCheckedIn) ...[
            const Divider(height: 24),
            _buildDetailRow(
              'Status',
              currentRecord!.isHoliday ? 'Hari Libur' : 'Hari Kerja',
              currentRecord!.isHoliday ? Colors.red : kcPrimaryColor,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Jam Reguler',
              '${currentRecord!.regularHours.toStringAsFixed(1)} jam',
              kcPrimaryColor,
            ),
            const SizedBox(height: 8),
            _buildDetailRow(
              'Jam Lembur',
              '${currentRecord!.overtimeHours.toStringAsFixed(1)} jam',
              kcSecondaryColor,
            ),
          ],
        ],
      ),
    );
  }

  String _calculateWorkHours() {
    if (currentRecord == null) return '0 jam';

    if (currentRecord!.checkOutTime != null) {
      // Already checked out, use the record's calculation
      return '${currentRecord!.totalHours.toStringAsFixed(1)} jam';
    } else {
      // Still working, calculate from check-in until now
      final now = DateTime.now();
      final difference = now.difference(currentRecord!.checkInTime);
      final hours = difference.inMinutes / 60;
      return '${hours.toStringAsFixed(1)} jam (berlangsung)';
    }
  }

  String _formatSalary(double amount) {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormat.format(amount);
  }

  Widget _buildInfoRow(String label, String value, IconData icon) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: kcPrimaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: kcPrimaryColor,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
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
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kcPrimaryTextColor,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value, Color valueColor) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kcSecondaryTextColor,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: valueColor,
          ),
        ),
      ],
    );
  }
}
