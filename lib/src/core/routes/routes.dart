import 'package:flutter/material.dart';

import 'package:flutter_result/src/core/routes/routes_names.dart';

// Screens
import 'package:flutter_result/src/features/home/home_screen.dart';
import 'package:flutter_result/src/features/http/http_screen.dart';

typedef RoutesType = Map<String, Widget Function(BuildContext context)>;

final RoutesType routes = {
  RouteNames.main: (context) => const HomeScreen(),
  RouteNames.http: (context) => const HttpScreen(),
};
