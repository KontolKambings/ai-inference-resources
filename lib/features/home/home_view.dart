import 'package:flutter/material.dart';
import 'package:gajimu/features/home/home_viewmodel.dart';
import 'package:gajimu/features/home/widgets/attendance_buttons.dart';
import 'package:gajimu/features/home/widgets/attendance_status.dart';
import 'package:gajimu/features/home/widgets/greeting_message.dart';
import 'package:gajimu/features/home/widgets/real_time_clock.dart';
import 'package:gajimu/features/home/widgets/salary_summary.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      appBar: AppBar(
        title: const Text('Absensi'),
        backgroundColor: kcPrimaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: viewModel.navigateToHistory,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: viewModel.navigateToSettings,
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Greeting message with dynamic time-based greeting
              GreetingMessage(
                currentTime: viewModel.currentTime,
                timeService: viewModel.timeService,
              ),

              const SizedBox(height: 20),

              // Real-time clock with ticking seconds
              RealTimeClock(
                currentTime: viewModel.currentTime,
                timeService: viewModel.timeService,
              ),

              const SizedBox(height: 20),

              // Attendance status
              AttendanceStatusWidget(
                status: viewModel.attendanceStatus,
              ),

              const SizedBox(height: 20),

              // Attendance buttons
              AttendanceButtons(
                status: viewModel.attendanceStatus,
                isHoliday: viewModel.isHoliday,
                onHolidayChanged: viewModel.setHoliday,
                onCheckIn: viewModel.checkIn,
                onCheckOut: viewModel.checkOut,
              ),

              const SizedBox(height: 20),

              // Salary summary
              SalarySummary(
                currentRecord: viewModel.currentRecord,
                timeService: viewModel.timeService,
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();

  @override
  void onViewModelReady(HomeViewModel viewModel) => viewModel.initialize();
}
