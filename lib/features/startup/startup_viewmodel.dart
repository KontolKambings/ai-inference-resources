import 'package:gajimu/app/app.locator.dart';
import 'package:gajimu/app/app.router.dart';
import 'package:gajimu/services/preferences_service.dart';
import 'package:gajimu/services/time_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class StartupViewModel extends BaseViewModel {
  final _navigationService = locator<NavigationService>();
  final _preferencesService = locator<PreferencesService>();
  final _timeService = locator<TimeService>();

  Future runStartupLogic() async {
    setBusy(true);

    try {
      // Initialize services
      await _preferencesService.init();
      _timeService.init();

      // Short delay for a better UX
      await Future.delayed(const Duration(seconds: 2));

      // Navigate to home screen
      await _navigationService.replaceWithHomeView();
    } catch (e) {
      // Handle any initialization errors
      setError(e);
    } finally {
      setBusy(false);
    }
  }
}
