import 'package:gajimu/features/history/history_view.dart';
import 'package:gajimu/features/home/home_view.dart';
import 'package:gajimu/features/settings/settings_view.dart';
import 'package:gajimu/features/startup/startup_view.dart';
import 'package:gajimu/services/preferences_service.dart';
import 'package:gajimu/services/salary_calculator_services.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:gajimu/shared/info_alert_dialog.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: StartupView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: HistoryView),
    MaterialRoute(page: SettingsView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: PreferencesService),
    LazySingleton(classType: TimeService),
    LazySingleton(classType: SalaryCalculatorService),
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
  ],
)
class App {}
