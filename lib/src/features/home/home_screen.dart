import 'package:flutter/material.dart';

import 'package:flutter_result/src/core/routes/routes_names.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Wrap(
          direction: Axis.vertical,
          spacing: 8.0,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  RouteNames.http,
                );
              },
              child: const Text('HTTP'),
            ),
          ],
        ),
      ),
    );
  }
}
