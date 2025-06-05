import 'package:gajimu/app/app.locator.dart';
import 'package:gajimu/models/attendance_record.dart';
import 'package:gajimu/services/preferences_service.dart';
import 'package:stacked/stacked.dart';

class HistoryViewModel extends BaseViewModel {
  final _preferencesService = locator<PreferencesService>();

  List<AttendanceRecord> _attendanceRecords = [];
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;

  bool get hasRecords => _attendanceRecords.isNotEmpty;

  void initialize() {
    loadAttendanceRecords();
  }

  void loadAttendanceRecords() {
    _attendanceRecords = _preferencesService.getAttendanceHistory();
    rebuildUi();
  }

  void updateRecord(int index, AttendanceRecord updatedRecord) {
    _preferencesService.updateAttendanceRecord(index, updatedRecord);
    loadAttendanceRecords();
  }

  void deleteRecord(int index) {
    _preferencesService.deleteAttendanceRecord(index);
    loadAttendanceRecords();
  }

  // Calculate total stats
  double get totalHours {
    double total = 0;
    for (final record in _attendanceRecords) {
      total += record.totalHours;
    }
    return total;
  }

  double get totalRegularHours {
    double total = 0;
    for (final record in _attendanceRecords) {
      total += record.regularHours;
    }
    return total;
  }

  double get totalOvertimeHours {
    double total = 0;
    for (final record in _attendanceRecords) {
      total += record.overtimeHours;
    }
    return total;
  }

  double get totalSalary {
    double total = 0;
    for (final record in _attendanceRecords) {
      total += record.totalSalary;
    }
    return total;
  }

  String get formattedTotalSalary {
    final currencyFormat = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    final amountString = totalSalary.toInt().toString();
    final formattedAmount = amountString.replaceAllMapped(
      currencyFormat,
      (Match m) => '${m[1]}.',
    );
    return 'Rp$formattedAmount';
  }
}
