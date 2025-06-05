import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajimu/features/settings/settings_viewmodel.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/button.dart';
import 'package:gajimu/shared/text_style.dart';
import 'package:stacked/stacked.dart';

class SettingsView extends StackedView<SettingsViewModel> {
  const SettingsView({super.key});

  @override
  Widget builder(
    BuildContext context,
    SettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pengaturan'),
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWageSettings(context, viewModel),
              const SizedBox(height: 24),
              _buildAppInfo(context),
              const SizedBox(height: 24),
              _buildDangerZone(context, viewModel),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWageSettings(BuildContext context, SettingsViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pengaturan Gaji',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kcPrimaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              'Gaji per Jam (Reguler)',
              viewModel.baseWageController,
              'Rp',
              viewModel.baseWageError,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 16),
            _buildTextField(
              context,
              'Gaji per Jam (Lembur)',
              viewModel.overtimeWageController,
              'Rp',
              viewModel.overtimeWageError,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
            ),
            const SizedBox(height: 20),
            CustomButton(
              text: 'Simpan Pengaturan',
              variant: ButtonVariant.primary,
              isFullWidth: true,
              isLoading: viewModel.isBusy,
              onPressed: viewModel.saveWageSettings,
            ),
            if (viewModel.hasSuccessfullySaved) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: kcSuccessColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: kcSuccessColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Pengaturan gaji berhasil disimpan',
                        style: TextStyle(
                          color: kcSuccessColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    String prefix,
    String? errorText, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kcPrimaryTextColor,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            prefixText: '$prefix ',
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 12,
            ),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kcSecondaryTextColor.withOpacity(0.3),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(
                color: kcSecondaryTextColor.withOpacity(0.3),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(
                color: kcPrimaryColor,
              ),
            ),
            errorText: errorText,
          ),
        ),
      ],
    );
  }

  Widget _buildAppInfo(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Informasi Aplikasi',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kcPrimaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Versi', '1.0.0'),
            const SizedBox(height: 8),
            _buildInfoRow('Bahasa', 'Indonesia'),
            const SizedBox(height: 8),
            _buildInfoRow('Mata Uang', 'IDR (Rupiah)'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: kcSecondaryTextColor,
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: kcPrimaryTextColor,
          ),
        ),
      ],
    );
  }

  Widget _buildDangerZone(BuildContext context, SettingsViewModel viewModel) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Zona Berbahaya',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: kcErrorColor,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Tindakan di bawah ini akan menghapus semua data aplikasi dan tidak dapat dikembalikan.',
              style: TextStyle(
                fontSize: 14,
                color: kcSecondaryTextColor,
              ),
            ),
            const SizedBox(height: 16),
            CustomButton(
              text: 'Reset Semua Data',
              variant: ButtonVariant.outline,
              isFullWidth: true,
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Konfirmasi Reset Data'),
                    content: const Text(
                      'Apakah Anda yakin ingin menghapus semua data? Tindakan ini tidak dapat dibatalkan.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Batal'),
                      ),
                      TextButton(
                        onPressed: () {
                          viewModel.resetAllData();
                          Navigator.of(context).pop();
                        },
                        child: const Text(
                          'Reset',
                          style: TextStyle(color: kcErrorColor),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  SettingsViewModel viewModelBuilder(BuildContext context) =>
      SettingsViewModel();

  @override
  void onViewModelReady(SettingsViewModel viewModel) => viewModel.initialize();
}
