import 'package:equatable/equatable.dart';
import 'package:intl/intl.dart';

class AttendanceRecord extends Equatable {
  final DateTime checkInTime;
  final DateTime? checkOutTime;
  final bool isHoliday;
  final double baseHourlyWage;
  final double overtimeHourlyWage;

  const AttendanceRecord({
    required this.checkInTime,
    this.checkOutTime,
    required this.isHoliday,
    required this.baseHourlyWage,
    required this.overtimeHourlyWage,
  });

  // Create a new instance with updated checkout time
  AttendanceRecord copyWith({
    DateTime? checkInTime,
    DateTime? checkOutTime,
    bool? isHoliday,
    double? baseHourlyWage,
    double? overtimeHourlyWage,
  }) {
    return AttendanceRecord(
      checkInTime: checkInTime ?? this.checkInTime,
      checkOutTime: checkOutTime ?? this.checkOutTime,
      isHoliday: isHoliday ?? this.isHoliday,
      baseHourlyWage: baseHourlyWage ?? this.baseHourlyWage,
      overtimeHourlyWage: overtimeHourlyWage ?? this.overtimeHourlyWage,
    );
  }

  // Calculate total hours worked
  double get totalHours {
    if (checkOutTime == null) return 0;

    final difference = checkOutTime!.difference(checkInTime);
    return difference.inMinutes / 60;
  }

  // Calculate regular hours (up to 8 hours for weekday)
  double get regularHours {
    if (isHoliday) return 0;
    return totalHours > 8 ? 8 : totalHours;
  }

  // Calculate overtime hours
  double get overtimeHours {
    if (isHoliday) return totalHours;
    return totalHours > 8 ? totalHours - 8 : 0;
  }

  // Calculate total salary for this record
  double get totalSalary {
    final regularPay = regularHours * baseHourlyWage;
    final overtimePay = overtimeHours * overtimeHourlyWage;
    return regularPay + overtimePay;
  }

  // Format the total salary as IDR
  String get formattedSalary {
    final currencyFormat = NumberFormat.currency(
      locale: 'id_ID',
      symbol: 'Rp',
      decimalDigits: 0,
    );
    return currencyFormat.format(totalSalary);
  }

  // Format date to string
  String get formattedDate {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(checkInTime);
  }

  // Format check in time to string
  String get formattedCheckInTime {
    return DateFormat('HH:mm', 'id_ID').format(checkInTime);
  }

  // Format check out time to string (if exists)
  String get formattedCheckOutTime {
    if (checkOutTime == null) return '-';
    return DateFormat('HH:mm', 'id_ID').format(checkOutTime!);
  }

  // Convert record to JSON for storage
  Map<String, dynamic> toJson() {
    return {
      'checkInTime': checkInTime.millisecondsSinceEpoch,
      'checkOutTime': checkOutTime?.millisecondsSinceEpoch,
      'isHoliday': isHoliday,
      'baseHourlyWage': baseHourlyWage,
      'overtimeHourlyWage': overtimeHourlyWage,
    };
  }

  // Create record from JSON storage
  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    return AttendanceRecord(
      checkInTime: DateTime.fromMillisecondsSinceEpoch(json['checkInTime']),
      checkOutTime: json['checkOutTime'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['checkOutTime'])
          : null,
      isHoliday: json['isHoliday'],
      baseHourlyWage: json['baseHourlyWage'],
      overtimeHourlyWage: json['overtimeHourlyWage'],
    );
  }

  @override
  List<Object?> get props => [
        checkInTime,
        checkOutTime,
        isHoliday,
        baseHourlyWage,
        overtimeHourlyWage,
      ];
}
