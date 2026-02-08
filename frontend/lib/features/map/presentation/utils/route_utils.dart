import 'package:aurabus/features/map/data/models/route_info.dart';

class RouteUtils {
  static int compareRoutes(RouteInfo a, RouteInfo b) {
    final regExp = RegExp(r'^(\d+)(.*)$');

    final matchA = regExp.firstMatch(a.routeShortName);
    final matchB = regExp.firstMatch(b.routeShortName);

    final numA = matchA != null ? int.parse(matchA.group(1)!) : null;
    final numB = matchB != null ? int.parse(matchB.group(1)!) : null;

    if (numA != null && numB != null) {
      final compareNums = numA.compareTo(numB);
      if (compareNums != 0) return compareNums;
      return a.routeShortName.compareTo(b.routeShortName);
    }

    if (numA != null) return -1;
    if (numB != null) return 1;

    return a.routeShortName.compareTo(b.routeShortName);
  }
}
