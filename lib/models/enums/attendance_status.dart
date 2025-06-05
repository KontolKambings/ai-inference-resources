enum AttendanceStatus {
  checkedIn,
  checkedOut,
  none,
}

extension AttendanceStatusExtension on AttendanceStatus {
  String get label {
    switch (this) {
      case AttendanceStatus.checkedIn:
        return 'Hari ini sudah Datang';
      case AttendanceStatus.checkedOut:
        return 'Hari ini sudah Absen';
      case AttendanceStatus.none:
        return 'Belum Absen';
    }
  }

  bool get isCheckedIn => this == AttendanceStatus.checkedIn;
  bool get isCheckedOut => this == AttendanceStatus.checkedOut;
  bool get hasNotChecked => this == AttendanceStatus.none;
}
