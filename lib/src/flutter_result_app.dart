import 'package:flutter/material.dart';

import 'package:flutter_result/src/core/routes/routes.dart';

class FlutterResultApp extends StatelessWidget {
  const FlutterResultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      routes: routes,
    );
  }
}
