import 'package:gajimu/main/bootstrap.dart';
import 'package:gajimu/models/enums/flavor.dart';
import 'package:gajimu/features/app/app_view.dart';

void main() {
  bootstrap(
    builder: () => const AppView(),
    flavor: Flavor.production,
  );
}
