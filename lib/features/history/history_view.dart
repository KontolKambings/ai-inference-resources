import 'package:flutter/material.dart';
import 'package:gajimu/features/history/history_viewmodel.dart';
import 'package:gajimu/features/history/widgets/edit_record_dialog.dart';
import 'package:gajimu/features/history/widgets/history_item.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';
import 'package:stacked/stacked.dart';

class HistoryView extends StackedView<HistoryViewModel> {
  const HistoryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HistoryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSummaryCard(viewModel),
              const SizedBox(height: 20),
              const Text(
                'Riwayat Absensi',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: kcPrimaryTextColor,
                ),
              ),
              const SizedBox(height: 12),
              Expanded(
                child: viewModel.hasRecords
                    ? _buildHistoryList(context, viewModel)
                    : _buildEmptyState(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(HistoryViewModel viewModel) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: kcPrimaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kcPrimaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Ringkasan Total',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Total Jam',
                '${viewModel.totalHours.toStringAsFixed(1)} jam',
                Icons.access_time,
              ),
              _buildSummaryItem(
                'Total Gaji',
                viewModel.formattedTotalSalary,
                Icons.monetization_on,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildSummaryItem(
                'Jam Reguler',
                '${viewModel.totalRegularHours.toStringAsFixed(1)} jam',
                Icons.work_outline,
              ),
              _buildSummaryItem(
                'Jam Lembur',
                '${viewModel.totalOvertimeHours.toStringAsFixed(1)} jam',
                Icons.more_time,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(String label, String value, IconData icon) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              icon,
              color: Colors.white.withOpacity(0.8),
              size: 16,
            ),
            const SizedBox(width: 4),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.white.withOpacity(0.8),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildHistoryList(BuildContext context, HistoryViewModel viewModel) {
    return ListView.builder(
      itemCount: viewModel.attendanceRecords.length,
      itemBuilder: (context, index) {
        final record = viewModel.attendanceRecords[index];
        return HistoryItem(
          record: record,
          onEdit: () {
            showDialog(
              context: context,
              builder: (context) => EditRecordDialog(
                record: record,
                onSave: (updatedRecord) {
                  viewModel.updateRecord(index, updatedRecord);
                },
              ),
            );
          },
          onDelete: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Konfirmasi'),
                content: const Text(
                  'Apakah Anda yakin ingin menghapus riwayat absensi ini?',
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Batal'),
                  ),
                  TextButton(
                    onPressed: () {
                      viewModel.deleteRecord(index);
                      Navigator.of(context).pop();
                    },
                    child: const Text(
                      'Hapus',
                      style: TextStyle(color: kcErrorColor),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history_rounded,
            size: 80,
            color: kcPrimaryColor.withOpacity(0.3),
          ),
          const SizedBox(height: 16),
          const Text(
            'Belum ada riwayat absensi',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: kcSecondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          const Text(
            'Riwayat absensi akan muncul setelah Anda melakukan absensi datang dan pulang',
            style: TextStyle(
              fontSize: 14,
              color: kcSecondaryTextColor,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  @override
  HistoryViewModel viewModelBuilder(BuildContext context) => HistoryViewModel();

  @override
  void onViewModelReady(HistoryViewModel viewModel) => viewModel.initialize();
}
