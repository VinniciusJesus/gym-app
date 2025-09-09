import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

Future<bool> hasInternet() async {
  return InternetConnection().hasInternetAccess;
}

Stream<InternetStatus> watchInternet() {
  return InternetConnection().onStatusChange;
}
