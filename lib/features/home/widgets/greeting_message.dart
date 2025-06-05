import 'package:flutter/material.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:gajimu/shared/text_style.dart';

class GreetingMessage extends StatelessWidget {
  final DateTime currentTime;
  final TimeService timeService;

  const GreetingMessage({
    super.key,
    required this.currentTime,
    required this.timeService,
  });

  @override
  Widget build(BuildContext context) {
    final greeting = timeService.getGreeting(currentTime);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        gradient: kcPrimaryGradient,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: kcPrimaryColor.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildGreetingIcon(),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  greeting,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  timeService.formatDate(currentTime),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGreetingIcon() {
    final hour = currentTime.hour;

    IconData icon;
    if (hour >= 4 && hour < 11) {
      icon = Icons.wb_sunny;
    } else if (hour >= 11 && hour < 15) {
      icon = Icons.wb_sunny_outlined;
    } else if (hour >= 15 && hour < 18) {
      icon = Icons.wb_twilight;
    } else if (hour >= 18 && hour < 19) {
      icon = Icons.nightlight_round;
    } else {
      icon = Icons.nightlight;
    }

    return Container(
      width: 50,
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        color: Colors.white,
        size: 30,
      ),
    );
  }
}
