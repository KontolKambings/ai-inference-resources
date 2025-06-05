import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TimeService {
  // Time of day categories in Indonesian
  static const _morningStart = 4; // Subuh - 04:00
  static const _dayStart = 11; // Pagi - 11:00
  static const _afternoonStart = 15; // Siang - 15:00
  static const _eveningStart = 18; // Sore - 18:00
  static const _nightStart = 19; // Malam - 19:00

  // Stream controller for time updates
  final _timeStreamController = StreamController<DateTime>.broadcast();
  Timer? _timer;

  // Getters
  Stream<DateTime> get timeStream => _timeStreamController.stream;

  // Initialize time service
  void init() {
    _startTimer();
  }

  // Start timer to update time every second
  void _startTimer() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _timeStreamController.add(DateTime.now());
    });
  }

  // Format current time as HH:mm:ss
  String formatTimeWithSeconds(DateTime time) {
    return DateFormat('HH:mm:ss').format(time);
  }

  // Format current time as HH:mm
  String formatTime(DateTime time) {
    return DateFormat('HH:mm').format(time);
  }

  // Format current date as dd MMMM yyyy
  String formatDate(DateTime date) {
    return DateFormat('dd MMMM yyyy', 'id_ID').format(date);
  }

  // Get greeting based on time of day
  String getGreeting(DateTime time) {
    final hour = time.hour;

    if (hour >= _morningStart && hour < _dayStart) {
      return 'Selamat Pagi';
    } else if (hour >= _dayStart && hour < _afternoonStart) {
      return 'Selamat Siang';
    } else if (hour >= _afternoonStart && hour < _eveningStart) {
      return 'Selamat Sore';
    } else if (hour >= _eveningStart && hour < _nightStart) {
      return 'Selamat Petang';
    } else {
      return 'Selamat Malam';
    }
  }

  // Format duration as HH:mm:ss
  String formatDuration(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '$hours jam $minutes menit $seconds detik';
  }

  // Format hours as decimal
  String formatHours(double hours) {
    return '${hours.toStringAsFixed(1)} jam';
  }

  // Check if two DateTimes are the same day
  bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  // Dispose resources
  void dispose() {
    _timer?.cancel();
    _timeStreamController.close();
  }
}
