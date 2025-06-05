import 'package:flutter/material.dart';
import 'package:gajimu/app/app.router.dart';
import 'package:gajimu/l10n/supported_locales.dart';
import 'package:gajimu/shared/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

class AppView extends StatelessWidget {
  const AppView({super.key});

  @override
  Widget build(BuildContext context) {
    return const _App();
  }
}

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MediaQuery.withClampedTextScaling(
      maxScaleFactor: 1.5,
      minScaleFactor: 0.5,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          /// Unfocus and hide keyboard when tap on white spaces
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: MaterialApp(
          initialRoute: Routes.startupView,
          onGenerateRoute: StackedRouter().onGenerateRoute,
          navigatorKey: StackedService.navigatorKey,
          navigatorObservers: [
            StackedService.routeObserver,
          ],
          localizationsDelegates: localizationsDelegates,
          supportedLocales: supportedLocales,
          theme: ThemeData(
            primaryColor: kcPrimaryColor,
            scaffoldBackgroundColor: kcBackgroundColor,
          ),
        ),
      ),
    );
  }
}
