import 'package:gajimu/models/attendance_record.dart';

class SalaryCalculatorService {
  // Calculate total working hours
  double calculateTotalHours(DateTime checkInTime, DateTime? checkOutTime) {
    if (checkOutTime == null) return 0;

    final difference = checkOutTime.difference(checkInTime);
    return difference.inMinutes / 60;
  }

  // Calculate regular working hours
  double calculateRegularHours(
    DateTime checkInTime,
    DateTime? checkOutTime,
    bool isHoliday,
  ) {
    if (isHoliday || checkOutTime == null) return 0;

    final totalHours = calculateTotalHours(checkInTime, checkOutTime);
    return totalHours > 8 ? 8 : totalHours;
  }

  // Calculate overtime hours
  double calculateOvertimeHours(
    DateTime checkInTime,
    DateTime? checkOutTime,
    bool isHoliday,
  ) {
    if (checkOutTime == null) return 0;

    final totalHours = calculateTotalHours(checkInTime, checkOutTime);

    if (isHoliday) {
      return totalHours;
    } else {
      return totalHours > 8 ? totalHours - 8 : 0;
    }
  }

  // Calculate total salary
  double calculateTotalSalary(
    DateTime checkInTime,
    DateTime? checkOutTime,
    bool isHoliday,
    double baseHourlyWage,
    double overtimeHourlyWage,
  ) {
    final regularHours = calculateRegularHours(
      checkInTime,
      checkOutTime,
      isHoliday,
    );

    final overtimeHours = calculateOvertimeHours(
      checkInTime,
      checkOutTime,
      isHoliday,
    );

    final regularPay = regularHours * baseHourlyWage;
    final overtimePay = overtimeHours * overtimeHourlyWage;

    return regularPay + overtimePay;
  }

  // Calculate total salary from multiple attendance records
  double calculateTotalSalaryFromRecords(List<AttendanceRecord> records) {
    double totalSalary = 0;

    for (final record in records) {
      totalSalary += record.totalSalary;
    }

    return totalSalary;
  }

  // Calculate total hours from multiple attendance records
  double calculateTotalHoursFromRecords(List<AttendanceRecord> records) {
    double totalHours = 0;

    for (final record in records) {
      totalHours += record.totalHours;
    }

    return totalHours;
  }

  // Calculate total regular hours from multiple attendance records
  double calculateTotalRegularHoursFromRecords(List<AttendanceRecord> records) {
    double totalRegularHours = 0;

    for (final record in records) {
      totalRegularHours += record.regularHours;
    }

    return totalRegularHours;
  }

  // Calculate total overtime hours from multiple attendance records
  double calculateTotalOvertimeHoursFromRecords(
      List<AttendanceRecord> records) {
    double totalOvertimeHours = 0;

    for (final record in records) {
      totalOvertimeHours += record.overtimeHours;
    }

    return totalOvertimeHours;
  }
}
