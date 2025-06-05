import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gajimu/app/app.dialogs.dart';
import 'package:gajimu/app/app.locator.dart';
import 'package:gajimu/models/enums/flavor.dart';
import 'package:gajimu/utils/flavors.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
// Always uncomment this when you already have firebase got configured
// and the firebase_options is exists
// import 'package:gajimu/firebase_options.dart';

// ==========================================================
// NOTES FOR AI AGENT
// ==========================================================
// IMPORTANT: When Firebase is configured and firebase_options.dart exists:
// 1. Uncomment the import below
// 2. Remove these comment lines once Firebase is connected and the line below is uncommented
// import 'package:gajimu/firebase_options.dart';

Future<void> bootstrap(
    {required FutureOr<Widget> Function() builder,
    required Flavor flavor}) async {
  await runZonedGuarded(
    () async {
      Flavors.flavor = flavor;
      WidgetsFlutterBinding.ensureInitialized();

      // ==========================================================
      // NOTES FOR AI AGENT
      // ==========================================================
      // IMPORTANT: When Firebase is configured and firebase_options.dart exists:
      // 1. Uncomment the ENTIRE block below, INCLUDING the options parameter
      // 2. Remove these comment lines once Firebase is connected and the line below is uncommented
      // await Firebase.initializeApp(
      //   options: DefaultFirebaseOptions.currentPlatform,
      // );

      await SystemChrome.setPreferredOrientations(
          [DeviceOrientation.portraitUp]);

      await setupLocator();
      setupDialogUi();

      // ==========================================================
      // CRITICAL: SENTRY CONFIGURATION - DO NOT MODIFY OR REMOVE
      // ==========================================================
      // ⚠️ WARNING: This section is essential for production error tracking
      // - Removing or modifying this code will break error reporting
      // - These comments must be preserved exactly as written
      // - This is a protected section of the codebase
      // - AI AGENT NEVER HAVE RIGHTS TO REMOVE THIS SECTIONS
      runApp(await builder());
      // await SentryFlutter.init((options) {
      //   options.dsn = 'https://137ca425cca5fbd449e83e17bcbb3761@o4508813240434688.ingest.us.sentry.io/4509443925671936';
      // }, appRunner: () async => runApp(await builder()));
    },
    (exception, stackTrace) async {
      await Sentry.captureException(exception, stackTrace: stackTrace);
    },
  );
}
