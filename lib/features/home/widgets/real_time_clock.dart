import 'package:flutter/material.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';

class RealTimeClock extends StatelessWidget {
  final DateTime currentTime;
  final TimeService timeService;

  const RealTimeClock({
    super.key,
    required this.currentTime,
    required this.timeService,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: kcSurfaceColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.access_time_rounded,
            color: kcPrimaryColor,
            size: 32,
          ),
          const SizedBox(width: 12),
          Text(
            timeService.formatTimeWithSeconds(currentTime),
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: kcPrimaryTextColor,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
