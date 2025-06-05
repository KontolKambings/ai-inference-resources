import 'dart:convert';

import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/models/enums/attendance_status.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  static const String _baseWageKey = 'base_wage';
  static const String _overtimeWageKey = 'overtime_wage';
  static const String _attendanceStatusKey = 'attendance_status';
  static const String _currentRecordKey = 'current_record';
  static const String _attendanceHistoryKey = 'attendance_history';

  late final SharedPreferences _prefs;

  // Initialize preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Base hourly wage
  Future<void> setBaseHourlyWage(double wage) async {
    await _prefs.setDouble(_baseWageKey, wage);
  }

  double getBaseHourlyWage() {
    return _prefs.getDouble(_baseWageKey) ?? 20000;
  }

  // Overtime hourly wage
  Future<void> setOvertimeHourlyWage(double wage) async {
    await _prefs.setDouble(_overtimeWageKey, wage);
  }

  double getOvertimeHourlyWage() {
    return _prefs.getDouble(_overtimeWageKey) ?? 30000;
  }

  // Attendance status
  Future<void> setAttendanceStatus(AttendanceStatus status) async {
    await _prefs.setInt(_attendanceStatusKey, status.index);
  }

  AttendanceStatus getAttendanceStatus() {
    final index = _prefs.getInt(_attendanceStatusKey);
    if (index == null) return AttendanceStatus.none;
    return AttendanceStatus.values[index];
  }

  // Current attendance record
  Future<void> setCurrentRecord(AttendanceRecord? record) async {
    if (record == null) {
      await _prefs.remove(_currentRecordKey);
    } else {
      final json = jsonEncode(record.toJson());
      await _prefs.setString(_currentRecordKey, json);
    }
  }

  AttendanceRecord? getCurrentRecord() {
    final json = _prefs.getString(_currentRecordKey);
    if (json == null) return null;

    try {
      final Map<String, dynamic> recordMap = jsonDecode(json);
      return AttendanceRecord.fromJson(recordMap);
    } catch (e) {
      return null;
    }
  }

  // Attendance history
  Future<void> saveAttendanceRecord(AttendanceRecord record) async {
    final records = getAttendanceHistory();
    records.add(record);
    await _saveAttendanceHistory(records);
  }

  Future<void> updateAttendanceRecord(
      int index, AttendanceRecord record) async {
    final records = getAttendanceHistory();
    if (index >= 0 && index < records.length) {
      records[index] = record;
      await _saveAttendanceHistory(records);
    }
  }

  Future<void> deleteAttendanceRecord(int index) async {
    final records = getAttendanceHistory();
    if (index >= 0 && index < records.length) {
      records.removeAt(index);
      await _saveAttendanceHistory(records);
    }
  }

  List<AttendanceRecord> getAttendanceHistory() {
    final jsonList = _prefs.getStringList(_attendanceHistoryKey) ?? [];
    final records = <AttendanceRecord>[];

    for (final json in jsonList) {
      try {
        final Map<String, dynamic> recordMap = jsonDecode(json);
        records.add(AttendanceRecord.fromJson(recordMap));
      } catch (e) {
        // Skip invalid entries
      }
    }

    // Sort by check-in time (newest first)
    records.sort((a, b) => b.checkInTime.compareTo(a.checkInTime));
    return records;
  }

  Future<void> _saveAttendanceHistory(List<AttendanceRecord> records) async {
    final jsonList =
        records.map((record) => jsonEncode(record.toJson())).toList();
    await _prefs.setStringList(_attendanceHistoryKey, jsonList);
  }

  // Clear all data
  Future<void> clearAllData() async {
    await _prefs.clear();
  }
}
