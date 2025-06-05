import 'package:flutter/material.dart';
import 'package:gajimu/app/app.locator.dart';
import 'package:gajimu/services/preferences_service.dart';
import 'package:stacked/stacked.dart';

class SettingsViewModel extends BaseViewModel {
  final _preferencesService = locator<PreferencesService>();

  final baseWageController = TextEditingController();
  final overtimeWageController = TextEditingController();

  String? _baseWageError;
  String? _overtimeWageError;
  bool _hasSuccessfullySaved = false;

  String? get baseWageError => _baseWageError;
  String? get overtimeWageError => _overtimeWageError;
  bool get hasSuccessfullySaved => _hasSuccessfullySaved;

  void initialize() {
    final baseWage = _preferencesService.getBaseHourlyWage();
    final overtimeWage = _preferencesService.getOvertimeHourlyWage();

    baseWageController.text = baseWage.toString();
    overtimeWageController.text = overtimeWage.toString();
  }

  bool _validateWages() {
    bool isValid = true;

    // Reset errors
    _baseWageError = null;
    _overtimeWageError = null;
    _hasSuccessfullySaved = false;

    // Validate base wage
    if (baseWageController.text.isEmpty) {
      _baseWageError = 'Gaji per jam harus diisi';
      isValid = false;
    } else {
      try {
        final value = double.parse(baseWageController.text);
        if (value <= 0) {
          _baseWageError = 'Gaji per jam harus lebih dari 0';
          isValid = false;
        }
      } catch (e) {
        _baseWageError = 'Format gaji tidak valid';
        isValid = false;
      }
    }

    // Validate overtime wage
    if (overtimeWageController.text.isEmpty) {
      _overtimeWageError = 'Gaji lembur per jam harus diisi';
      isValid = false;
    } else {
      try {
        final value = double.parse(overtimeWageController.text);
        if (value <= 0) {
          _overtimeWageError = 'Gaji lembur per jam harus lebih dari 0';
          isValid = false;
        }
      } catch (e) {
        _overtimeWageError = 'Format gaji lembur tidak valid';
        isValid = false;
      }
    }

    rebuildUi();
    return isValid;
  }

  Future<void> saveWageSettings() async {
    if (!_validateWages()) return;

    setBusy(true);

    try {
      final baseWage = double.parse(baseWageController.text);
      final overtimeWage = double.parse(overtimeWageController.text);

      await _preferencesService.setBaseHourlyWage(baseWage);
      await _preferencesService.setOvertimeHourlyWage(overtimeWage);

      _hasSuccessfullySaved = true;
    } catch (e) {
      // Handle error if needed
    } finally {
      setBusy(false);
    }
  }

  Future<void> resetAllData() async {
    setBusy(true);

    try {
      await _preferencesService.clearAllData();

      // Reset the UI to default values
      baseWageController.text = '20000';
      overtimeWageController.text = '30000';

      _hasSuccessfullySaved = false;
    } catch (e) {
      // Handle error if needed
    } finally {
      setBusy(false);
    }
  }

  @override
  void dispose() {
    baseWageController.dispose();
    overtimeWageController.dispose();
    super.dispose();
  }
}
