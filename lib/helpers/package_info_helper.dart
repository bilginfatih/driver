import 'package:package_info_plus/package_info_plus.dart';

class PackageInfoHelper {
  static final PackageInfoHelper shared = PackageInfoHelper._instance();

  factory PackageInfoHelper() {
    return shared;
  }

  PackageInfoHelper._instance();

  static PackageInfo? info;

  static initialize() async {
    info = await PackageInfo.fromPlatform();
  }
}
