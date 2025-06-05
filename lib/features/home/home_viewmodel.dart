import 'dart:async';

import 'package:gajimu/app/app.locator.dart';
import 'package:gajimu/app/app.router.dart';
import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/models/enums/attendance_status.dart';
import 'package:gajimu/services/preferences_service.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class HomeViewModel extends BaseViewModel {
  final _preferencesService = locator<PreferencesService>();
  final _navigationService = locator<NavigationService>();
  final _timeService = locator<TimeService>();

  DateTime _currentTime = DateTime.now();
  AttendanceStatus _attendanceStatus = AttendanceStatus.none;
  AttendanceRecord? _currentRecord;
  bool _isHoliday = false;
  StreamSubscription? _timeSubscription;

  // Getters
  DateTime get currentTime => _currentTime;
  AttendanceStatus get attendanceStatus => _attendanceStatus;
  AttendanceRecord? get currentRecord => _currentRecord;
  TimeService get timeService => _timeService;
  bool get isHoliday => _isHoliday;

  // Initialize the view model
  void initialize() {
    // Load attendance status and current record
    _loadAttendanceStatus();

    // Subscribe to time updates
    _timeSubscription = _timeService.timeStream.listen((time) {
      _currentTime = time;
      rebuildUi();
    });
  }

  // Load attendance status and current record from preferences
  void _loadAttendanceStatus() {
    _attendanceStatus = _preferencesService.getAttendanceStatus();
    _currentRecord = _preferencesService.getCurrentRecord();

    // Set holiday status from current record or default to false
    _isHoliday = _currentRecord?.isHoliday ?? false;

    rebuildUi();
  }

  // Set holiday status
  void setHoliday(bool value) {
    _isHoliday = value;
    rebuildUi();
  }

  // Check in
  void checkIn() async {
    final baseWage = _preferencesService.getBaseHourlyWage();
    final overtimeWage = _preferencesService.getOvertimeHourlyWage();

    // Create a new attendance record
    final newRecord = AttendanceRecord(
      checkInTime: DateTime.now(),
      isHoliday: _isHoliday,
      baseHourlyWage: baseWage,
      overtimeHourlyWage: overtimeWage,
    );

    // Update status and save record
    _attendanceStatus = AttendanceStatus.checkedIn;
    _currentRecord = newRecord;

    await _preferencesService.setAttendanceStatus(_attendanceStatus);
    await _preferencesService.setCurrentRecord(_currentRecord);

    rebuildUi();
  }

  // Check out
  void checkOut() async {
    if (_currentRecord == null) return;

    // Update the current record with check-out time
    final updatedRecord = _currentRecord!.copyWith(
      checkOutTime: DateTime.now(),
    );

    // Update status and save record
    _attendanceStatus = AttendanceStatus.checkedOut;
    _currentRecord = updatedRecord;

    await _preferencesService.setAttendanceStatus(_attendanceStatus);
    await _preferencesService.setCurrentRecord(_currentRecord);

    // Save to attendance history
    await _preferencesService.saveAttendanceRecord(_currentRecord!);

    rebuildUi();
  }

  // Navigate to history screen
  void navigateToHistory() {
    _navigationService.navigateToHistoryView();
  }

  // Navigate to settings screen
  void navigateToSettings() {
    _navigationService.navigateToSettingsView();
  }

  @override
  void dispose() {
    _timeSubscription?.cancel();
    super.dispose();
  }
}
